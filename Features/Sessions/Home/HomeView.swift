import SwiftUI
import SwiftData
import UserNotifications
import BedTimerKit

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel = HomeViewModel()
    @State private var selectedSession: BedSession?
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
    
    var body: some View {
        NavigationStack {
            content
                .navigationTitle("BedTimer")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: startSession) {
                            Label("Start", systemImage: "plus")
                        }
                    }
                }
        }
        .task {
            viewModel.configure(with: modelContext)
        }
        .alert(
            "Error",
            isPresented: Binding(
                get: { viewModel.errorMessage != nil },
                set: { _ in viewModel.errorMessage = nil }
            ),
            actions: {},
            message: { Text(viewModel.errorMessage ?? "") }
        )
        .sheet(item: $selectedSession) { session in
            SessionDetailView(
                session: session,
                progress: viewModel.progress(for: session),
                statusMessage: viewModel.statusMessage(for: session),
                caption: viewModel.caption(for: session),
                formattedDuration: { minutes in viewModel.formattedDuration(minutes: minutes) },
                dateFormatter: dateFormatter
            )
            .presentationDetents([.medium, .large])
        }
    }
    
    @ViewBuilder
    private var content: some View {
        if viewModel.isLoading && viewModel.sessions.isEmpty {
            ProgressView("Loading Sessions")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            List {
                if !viewModel.onboardingTips.isEmpty {
                    tipsSection
                }
                notificationSection
                sessionSection
            }
            .listStyle(.insetGrouped)
        }
    }
    
    private var tipsSection: some View {
        Section("Tips") {
            ForEach(Array(viewModel.onboardingTips.enumerated()), id: \\.offset) { _, tip in
                Label(tip, systemImage: "lightbulb")
                    .font(.subheadline)
            }
        }
    }
    
    private var notificationSection: some View {
        Section("Notifications") {
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 8) {
                    Image(systemName: notificationStatusIcon)
                        .foregroundStyle(notificationStatusColor)
                    Text(notificationStatusHeadline)
                        .font(.headline)
                }
                Text(notificationStatusDescription)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                if viewModel.isRequestingNotificationPermission {
                    ProgressView("Requesting permission…")
                        .font(.footnote)
                } else if needsNotificationPermissionButton {
                    Button(action: requestNotificationPermission) {
                        Label("Enable Notifications", systemImage: "bell.badge")
                    }
                    .buttonStyle(.borderedProminent)
                }
                VStack(alignment: .leading, spacing: 6) {
                    if viewModel.isSchedulingTestAlarm {
                        ProgressView("Scheduling test alarm…")
                            .font(.footnote)
                    } else {
                        Button(action: sendTestAlarm) {
                            Label("Send Test Alarm", systemImage: "bell.badge.fill")
                        }
                        .buttonStyle(.bordered)
                        .disabled(!viewModel.canSendTestAlarm)
                    }
                    Text("A 1-minute alarm helps confirm permissions and sound settings.")
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                }
            }
            .padding(.vertical, 4)
        }
    }
    
    private var sessionSection: some View {
        Section("Recent Sessions") {
            if viewModel.sessions.isEmpty {
                emptySessionsRow
            } else {
                ForEach(viewModel.sessions, id: \\.id) { session in
                    sessionRow(session)
                }
                .onDelete(perform: deleteSessions)
            }
        }
    }
    
    private var emptySessionsRow: some View {
        VStack(spacing: 12) {
            Image(systemName: "bed.double")
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .foregroundStyle(.secondary)
                .padding(.top, 8)
            Text("No sessions yet")
                .font(.headline)
            Text("Tap Start to begin tracking your morning.")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.vertical, 16)
    }
    
    private func sessionRow(_ session: BedSession) -> some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 6) {
                Text(dateFormatter.string(from: session.scheduledAlarm))
                    .font(.headline)
                Text(viewModel.statusMessage(for: session))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Text(viewModel.caption(for: session))
                    .font(.caption)
                    .foregroundStyle(.tertiary)
                ProgressView(value: viewModel.progress(for: session))
                    .tint(session.isCompleted ? .green : .accentColor)
            }
            Spacer()
            if session.isInProgress {
                Button("End") {
                    Task { await viewModel.endSession(session) }
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
        .onTapGesture {
            selectedSession = session
        }
    }
    
    private var notificationStatusHeadline: String {
        switch viewModel.notificationStatus {
        case .authorized:
            return "Notifications enabled"
        case .provisional:
            return "Notifications provisional"
        case .denied:
            return "Notifications blocked"
        case .notDetermined:
            return "Notifications not set"
        case .ephemeral:
            return "Notifications temporary"
        @unknown default:
            return "Notifications status unknown"
        }
    }
    
    private var notificationStatusDescription: String {
        switch viewModel.notificationStatus {
        case .authorized:
            return "You're all set. Try sending a quick test alarm to confirm."
        case .provisional:
            return "Alerts show quietly. Promote them in Settings for full alerts."
        case .denied:
            return "Go to Settings → Notifications → BedTimer to re-enable alerts."
        case .notDetermined:
            return "Allow notifications so BedTimer can remind you when to get up."
        case .ephemeral:
            return "Temporary permission granted. Grant full access in Settings."
        @unknown default:
            return "We couldn't determine the current notification status."
        }
    }
    
    private var notificationStatusIcon: String {
        switch viewModel.notificationStatus {
        case .authorized:
            return "bell.fill"
        case .provisional:
            return "bell"
        case .denied:
            return "bell.slash"
        case .notDetermined:
            return "bell.badge"
        case .ephemeral:
            return "bell.and.waveform"
        @unknown default:
            return "questionmark.circle"
        }
    }
    
    private var notificationStatusColor: Color {
        switch viewModel.notificationStatus {
        case .authorized:
            return .green
        case .provisional:
            return .yellow
        case .denied:
            return .red
        case .notDetermined:
            return .blue
        case .ephemeral:
            return .orange
        @unknown default:
            return .gray
        }
    }
    
    private var needsNotificationPermissionButton: Bool {
        switch viewModel.notificationStatus {
        case .authorized, .provisional:
            return false
        default:
            return true
        }
    }
    
    private func deleteSessions(at offsets: IndexSet) {
        for index in offsets {
            let session = viewModel.sessions[index]
            Task { await viewModel.deleteSession(session) }
        }
    }
    
    private func startSession() {
        Task { await viewModel.startNewSession() }
    }
    
    private func requestNotificationPermission() {
        Task { await viewModel.requestNotificationPermission() }
    }
    
    private func sendTestAlarm() {
        Task { await viewModel.scheduleTestAlarm(after: 60) }
    }
}

#Preview {
    HomeView()
        .modelContainer(for: BedSession.self, inMemory: true)
}
