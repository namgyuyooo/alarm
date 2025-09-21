import Foundation
import UserNotifications

public protocol AlarmRepositoryProtocol {
    func requestNotificationPermission() async throws -> Bool
    func scheduleAlarm(for date: Date, title: String, body: String) async throws
    func cancelAlarm(with identifier: String) async throws
    func cancelAllAlarms() async throws
    func getPendingAlarms() async throws -> [UNNotificationRequest]
}

public final class AlarmRepository: AlarmRepositoryProtocol {
    private let notificationCenter = UNUserNotificationCenter.current()
    
    public init() {}
    
    public func requestNotificationPermission() async throws -> Bool {
        let settings = await notificationCenter.notificationSettings()
        
        switch settings.authorizationStatus {
        case .authorized, .provisional:
            return true
        case .denied:
            return false
        case .notDetermined:
            return try await requestAuthorization()
        case .ephemeral:
            return false
        @unknown default:
            return false
        }
    }
    
    private func requestAuthorization() async throws -> Bool {
        let granted = try await notificationCenter.requestAuthorization(options: [.alert, .sound, .badge])
        return granted
    }
    
    public func scheduleAlarm(for date: Date, title: String, body: String) async throws {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        content.categoryIdentifier = "BED_TIMER_ALARM"
        
        // 알림 액션 추가
        let startAction = UNNotificationAction(
            identifier: "START_COUNTDOWN",
            title: "Start Countdown",
            options: []
        )
        let snoozeAction = UNNotificationAction(
            identifier: "SNOOZE",
            title: "Snooze",
            options: []
        )
        let outOfBedAction = UNNotificationAction(
            identifier: "OUT_OF_BED",
            title: "Out of Bed",
            options: [.foreground]
        )
        
        let category = UNNotificationCategory(
            identifier: "BED_TIMER_ALARM",
            actions: [startAction, snoozeAction, outOfBedAction],
            intentIdentifiers: [],
            options: []
        )
        
        notificationCenter.setNotificationCategories([category])
        
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date),
            repeats: false
        )
        
        let request = UNNotificationRequest(
            identifier: "BED_TIMER_\(date.timeIntervalSince1970)",
            content: content,
            trigger: trigger
        )
        
        try await notificationCenter.add(request)
    }
    
    public func cancelAlarm(with identifier: String) async throws {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
    }
    
    public func cancelAllAlarms() async throws {
        notificationCenter.removeAllPendingNotificationRequests()
    }
    
    public func getPendingAlarms() async throws -> [UNNotificationRequest] {
        return await notificationCenter.pendingNotificationRequests()
    }
}

// MARK: - Notification Actions
public enum AlarmAction: String, CaseIterable {
    case startCountdown = "START_COUNTDOWN"
    case snooze = "SNOOZE"
    case outOfBed = "OUT_OF_BED"
    
    public var title: String {
        switch self {
        case .startCountdown:
            return "Start Countdown"
        case .snooze:
            return "Snooze"
        case .outOfBed:
            return "Out of Bed"
        }
    }
}