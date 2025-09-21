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

extension BedSession: Identifiable {}

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
        return isCompleted && actualMinutes <= goalMinutes
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
    
    /// 목표 시간 대비 진행률 (0~1)
    var goalProgress: Double {
        guard goalMinutes > 0, let acknowledgedAt else { return 0 }
        let elapsed: TimeInterval
        if let outOfBedAt {
            elapsed = outOfBedAt.timeIntervalSince(acknowledgedAt)
        } else {
            elapsed = Date().timeIntervalSince(acknowledgedAt)
        }
        let total = Double(goalMinutes) * 60
        guard total > 0 else { return 0 }
        return min(1, max(0, elapsed / total))
    }
    
    /// 경과 시간 (분) — 진행 중에도 현재 시각 기준으로 계산
    var elapsedMinutes: Int {
        guard let acknowledgedAt else { return 0 }
        let end = outOfBedAt ?? Date()
        let elapsed = end.timeIntervalSince(acknowledgedAt)
        return max(0, Int(elapsed / 60))
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
