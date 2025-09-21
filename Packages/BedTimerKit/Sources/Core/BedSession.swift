import Foundation
import SwiftData

@Model
public final class BedSession {
    public var id: UUID
    public var scheduledAlarm: Date
    public var goalMinutes: Int
    public var acknowledgedAt: Date?
    public var outOfBedAt: Date?
    public var createdAt: Date
    public var updatedAt: Date
    
    public init(
        id: UUID = UUID(),
        scheduledAlarm: Date,
        goalMinutes: Int,
        acknowledgedAt: Date? = nil,
        outOfBedAt: Date? = nil
    ) {
        self.id = id
        self.scheduledAlarm = scheduledAlarm
        self.goalMinutes = goalMinutes
        self.acknowledgedAt = acknowledgedAt
        self.outOfBedAt = outOfBedAt
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}

// MARK: - Computed Properties
public extension BedSession {
    /// 실제 머무른 시간 (분)
    var actualMinutes: Int {
        guard let acknowledged = acknowledgedAt,
              let outOfBed = outOfBedAt else {
            return 0
        }
        return Int(outOfBed.timeIntervalSince(acknowledged) / 60)
    }
    
    /// 목표 달성 여부
    var metGoal: Bool {
        return actualMinutes <= goalMinutes
    }
    
    /// 세션 완료 여부
    var isCompleted: Bool {
        return acknowledgedAt != nil && outOfBedAt != nil
    }
    
    /// 세션 진행 중 여부
    var isInProgress: Bool {
        return acknowledgedAt != nil && outOfBedAt == nil
    }
    
    /// 목표까지 남은 시간 (분)
    var remainingMinutes: Int {
        guard let acknowledged = acknowledgedAt,
              outOfBedAt == nil else {
            return goalMinutes
        }
        let elapsed = Int(Date().timeIntervalSince(acknowledged) / 60)
        return max(0, goalMinutes - elapsed)
    }
}

// MARK: - Actions
public extension BedSession {
    /// 세션 시작 (알람 인지)
    func start() {
        acknowledgedAt = Date()
        updatedAt = Date()
    }
    
    /// 세션 종료 (침대에서 나감)
    func end() {
        outOfBedAt = Date()
        updatedAt = Date()
    }
    
    /// 세션 삭제
    func delete() {
        acknowledgedAt = nil
        outOfBedAt = nil
        updatedAt = Date()
    }
}