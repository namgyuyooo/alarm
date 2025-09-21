import Foundation
import SwiftData
import UserNotifications
import BedTimerKit

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var sessions: [BedSession] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var notificationStatus: UNAuthorizationStatus = .notDetermined
    @Published var isRequestingNotificationPermission: Bool = false
    @Published var isSchedulingTestAlarm: Bool = false
    
    private var sessionRepository: SessionRepositoryProtocol?
    private let alarmRepository: AlarmRepositoryProtocol
    private let durationFormatter: DateComponentsFormatter
    
    init(alarmRepository: AlarmRepositoryProtocol = AlarmRepository()) {
        self.alarmRepository = alarmRepository
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .abbreviated
        formatter.zeroFormattingBehavior = [.dropLeading, .dropTrailing]
        self.durationFormatter = formatter
    }

    var canSendTestAlarm: Bool {
        switch notificationStatus {
        case .authorized, .provisional:
            return true
        default:
            return false
        }
    }
    
    var onboardingTips: [String] {
        var items: [String] = []
        if sessions.isEmpty {
            items.append("Start your first BedTimer session to measure your morning linger.")
        }
        switch notificationStatus {
        case .authorized:
            break
        case .provisional:
            items.append("Promote notifications in Settings so alarms can break through focus modes.")
        case .denied:
            items.append("Enable notifications in Settings → Notifications → BedTimer to get alarm prompts.")
        case .notDetermined:
            items.append("Grant notification permission so BedTimer can remind you when it's time to get up.")
        case .ephemeral:
            items.append("Notifications are temporarily allowed. Grant full access in Settings for reliable alarms.")
        @unknown default:
            items.append("Review your notification settings to ensure alarms can reach you.")
        }
        if sessions.contains(where: { $0.isInProgress }) == false && !sessions.isEmpty {
            items.append("Tap a session to review your stats and streak progress.")
        }
        return items
    }
    
    func configure(with modelContext: ModelContext) {
        guard sessionRepository == nil else { return }
        sessionRepository = SessionRepository(modelContext: modelContext)
        Task { await loadSessions() }
        Task { await refreshNotificationStatus() }
    }
    
    func loadSessions() async {
        guard let sessionRepository else { return }
        isLoading = true
        defer { isLoading = false }
        do {
            sessions = try await sessionRepository.fetchRecentSessions(limit: 20)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func startNewSession(goalMinutes: Int = 5) async {
        guard let sessionRepository else { return }
        let session = BedSession(
            scheduledAlarm: Date(),
            goalMinutes: goalMinutes
        )
        session.start()
        do {
            try await sessionRepository.save(session)
            await loadSessions()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func endSession(_ session: BedSession) async {
        guard let sessionRepository else { return }
        session.end()
        do {
            try await sessionRepository.update(session)
            await loadSessions()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func deleteSession(_ session: BedSession) async {
        guard let sessionRepository else { return }
        do {
            try await sessionRepository.delete(session)
            await loadSessions()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func refreshNotificationStatus() async {
        let status = await alarmRepository.notificationAuthorizationStatus()
        notificationStatus = status
    }
    
    func requestNotificationPermission() async {
        isRequestingNotificationPermission = true
        defer { isRequestingNotificationPermission = false }
        do {
            let granted = try await alarmRepository.requestNotificationPermission()
            await refreshNotificationStatus()
            if !granted {
                errorMessage = "Notifications are still disabled. Please enable them in Settings."
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func scheduleTestAlarm(after interval: TimeInterval = 60) async {
        guard canSendTestAlarm else {
            errorMessage = "Enable notifications before sending a test alarm."
            return
        }
        isSchedulingTestAlarm = true
        defer { isSchedulingTestAlarm = false }
        do {
            try await alarmRepository.scheduleTestAlarm(after: interval)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func progress(for session: BedSession) -> Double {
        if session.isCompleted {
            return min(1, Double(session.actualMinutes) / Double(max(1, session.goalMinutes)))
        }
        return session.goalProgress
    }
    
    func statusMessage(for session: BedSession) -> String {
        if session.isCompleted {
            let actual = formattedDuration(minutes: session.actualMinutes)
            return "Completed in \(actual)"
        }
        if session.isInProgress {
            let remaining = formattedDuration(minutes: session.remainingMinutes)
            return "\(remaining) remaining"
        }
        return "Ready to start"
    }
    
    func caption(for session: BedSession) -> String {
        switch (session.acknowledgedAt, session.outOfBedAt) {
        case (.some(let start), .some(let end)):
            let startString = start.formatted(date: .omitted, time: .shortened)
            let endString = end.formatted(date: .omitted, time: .shortened)
            return "Started at \(startString) · Finished at \(endString)"
        case (.some(let start), nil):
            let startString = start.formatted(date: .omitted, time: .shortened)
            return "Started at \(startString)"
        default:
            return "Scheduled at \(session.scheduledAlarm.formatted(date: .omitted, time: .shortened))"
        }
    }
    
    func formattedDuration(minutes: Int) -> String {
        let seconds = max(0, minutes * 60)
        return durationFormatter.string(from: TimeInterval(seconds)) ?? "\(minutes) min"
    }
}
