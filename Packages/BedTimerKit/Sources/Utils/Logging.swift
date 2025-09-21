import Foundation
import os.log

public struct BedTimerLogger {
    public static let shared = BedTimerLogger()
    
    private let subsystem = "com.bedtimer.app"
    
    private init() {}
    
    // MARK: - Category Loggers
    public let session = Logger(subsystem: "com.bedtimer.app", category: "session")
    public let alarm = Logger(subsystem: "com.bedtimer.app", category: "alarm")
    public let sync = Logger(subsystem: "com.bedtimer.app", category: "sync")
    public let ui = Logger(subsystem: "com.bedtimer.app", category: "ui")
    public let network = Logger(subsystem: "com.bedtimer.app", category: "network")
    public let analytics = Logger(subsystem: "com.bedtimer.app", category: "analytics")
    
    // MARK: - Logging Levels
    public enum LogLevel: String, CaseIterable {
        case debug = "DEBUG"
        case info = "INFO"
        case warning = "WARNING"
        case error = "ERROR"
        case critical = "CRITICAL"
        
        var osLogType: OSLogType {
            switch self {
            case .debug:
                return .debug
            case .info:
                return .info
            case .warning:
                return .default
            case .error:
                return .error
            case .critical:
                return .fault
            }
        }
    }
    
    // MARK: - Public Logging Methods
    public func log(_ level: LogLevel, message: String, category: String = "general", metadata: [String: Any] = [:]) {
        let logger = Logger(subsystem: subsystem, category: category)
        
        let formattedMessage = formatMessage(level: level, message: message, metadata: metadata)
        
        switch level {
        case .debug:
            logger.debug("\(formattedMessage)")
        case .info:
            logger.info("\(formattedMessage)")
        case .warning:
            logger.warning("\(formattedMessage)")
        case .error:
            logger.error("\(formattedMessage)")
        case .critical:
            logger.critical("\(formattedMessage)")
        }
    }
    
    // MARK: - Convenience Methods
    public func debug(_ message: String, category: String = "general", metadata: [String: Any] = [:]) {
        log(.debug, message: message, category: category, metadata: metadata)
    }
    
    public func info(_ message: String, category: String = "general", metadata: [String: Any] = [:]) {
        log(.info, message: message, category: category, metadata: metadata)
    }
    
    public func warning(_ message: String, category: String = "general", metadata: [String: Any] = [:]) {
        log(.warning, message: message, category: category, metadata: metadata)
    }
    
    public func error(_ message: String, category: String = "general", metadata: [String: Any] = [:]) {
        log(.error, message: message, category: category, metadata: metadata)
    }
    
    public func critical(_ message: String, category: String = "general", metadata: [String: Any] = [:]) {
        log(.critical, message: message, category: category, metadata: metadata)
    }
    
    // MARK: - Private Methods
    private func formatMessage(level: LogLevel, message: String, metadata: [String: Any]) -> String {
        var formattedMessage = "[\(level.rawValue)] \(message)"
        
        if !metadata.isEmpty {
            let metadataString = metadata.map { "\($0.key): \($0.value)" }.joined(separator: ", ")
            formattedMessage += " | \(metadataString)"
        }
        
        return formattedMessage
    }
}

// MARK: - Global Logger Instance
public let logger = BedTimerLogger.shared

// MARK: - Logging Extensions
public extension BedTimerLogger {
    /// 세션 관련 로깅
    func logSessionStart(_ sessionId: UUID, goalMinutes: Int) {
        session.info("Session started", metadata: [
            "session_id": sessionId.uuidString,
            "goal_minutes": goalMinutes
        ])
    }
    
    func logSessionEnd(_ sessionId: UUID, actualMinutes: Int, metGoal: Bool) {
        session.info("Session ended", metadata: [
            "session_id": sessionId.uuidString,
            "actual_minutes": actualMinutes,
            "met_goal": metGoal
        ])
    }
    
    func logSessionDelete(_ sessionId: UUID) {
        session.info("Session deleted", metadata: [
            "session_id": sessionId.uuidString
        ])
    }
}

public extension BedTimerLogger {
    /// 알람 관련 로깅
    func logAlarmScheduled(_ alarmDate: Date, identifier: String) {
        alarm.info("Alarm scheduled", metadata: [
            "alarm_date": alarmDate.ISO8601Format(),
            "identifier": identifier
        ])
    }
    
    func logAlarmTriggered(_ identifier: String) {
        alarm.info("Alarm triggered", metadata: [
            "identifier": identifier
        ])
    }
    
    func logAlarmAction(_ action: String, identifier: String) {
        alarm.info("Alarm action taken", metadata: [
            "action": action,
            "identifier": identifier
        ])
    }
}