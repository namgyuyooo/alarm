import Foundation
import SwiftData

public protocol SessionRepositoryProtocol {
    func save(_ session: BedSession) async throws
    func fetchAll() async throws -> [BedSession]
    func fetchById(_ id: UUID) async throws -> BedSession?
    func delete(_ session: BedSession) async throws
    func deleteById(_ id: UUID) async throws
    func fetchRecentSessions(limit: Int) async throws -> [BedSession]
    func fetchSessionsInDateRange(_ startDate: Date, _ endDate: Date) async throws -> [BedSession]
    func getStatistics() async throws -> SessionStatistics
}

public struct SessionStatistics {
    public let totalSessions: Int
    public let completedSessions: Int
    public let goalSuccessRate: Double
    public let averageActualMinutes: Double
    public let currentStreak: Int
    public let longestStreak: Int
    
    public init(
        totalSessions: Int,
        completedSessions: Int,
        goalSuccessRate: Double,
        averageActualMinutes: Double,
        currentStreak: Int,
        longestStreak: Int
    ) {
        self.totalSessions = totalSessions
        self.completedSessions = completedSessions
        self.goalSuccessRate = goalSuccessRate
        self.averageActualMinutes = averageActualMinutes
        self.currentStreak = currentStreak
        self.longestStreak = longestStreak
    }
}

@available(iOS 17.0, watchOS 10.0, *)
public final class SessionRepository: SessionRepositoryProtocol {
    private let modelContext: ModelContext
    
    public init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    public func save(_ session: BedSession) async throws {
        modelContext.insert(session)
        try modelContext.save()
    }
    
    public func fetchAll() async throws -> [BedSession] {
        let descriptor = FetchDescriptor<BedSession>(
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        return try modelContext.fetch(descriptor)
    }
    
    public func fetchById(_ id: UUID) async throws -> BedSession? {
        let descriptor = FetchDescriptor<BedSession>(
            predicate: #Predicate { $0.id == id }
        )
        return try modelContext.fetch(descriptor).first
    }
    
    public func delete(_ session: BedSession) async throws {
        modelContext.delete(session)
        try modelContext.save()
    }
    
    public func deleteById(_ id: UUID) async throws {
        guard let session = try await fetchById(id) else { return }
        try await delete(session)
    }
    
    public func fetchRecentSessions(limit: Int = 10) async throws -> [BedSession] {
        let descriptor = FetchDescriptor<BedSession>(
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)],
            fetchLimit: limit
        )
        return try modelContext.fetch(descriptor)
    }
    
    public func fetchSessionsInDateRange(_ startDate: Date, _ endDate: Date) async throws -> [BedSession] {
        let descriptor = FetchDescriptor<BedSession>(
            predicate: #Predicate { session in
                session.createdAt >= startDate && session.createdAt <= endDate
            },
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        return try modelContext.fetch(descriptor)
    }
    
    public func getStatistics() async throws -> SessionStatistics {
        let allSessions = try await fetchAll()
        let completedSessions = allSessions.filter { $0.isCompleted }
        
        let totalSessions = allSessions.count
        let completedCount = completedSessions.count
        let goalSuccessRate = completedCount > 0 ? 
            Double(completedSessions.filter { $0.metGoal }.count) / Double(completedCount) : 0.0
        let averageActualMinutes = completedCount > 0 ?
            Double(completedSessions.map { $0.actualMinutes }.reduce(0, +)) / Double(completedCount) : 0.0
        
        let (currentStreak, longestStreak) = calculateStreaks(completedSessions)
        
        return SessionStatistics(
            totalSessions: totalSessions,
            completedSessions: completedCount,
            goalSuccessRate: goalSuccessRate,
            averageActualMinutes: averageActualMinutes,
            currentStreak: currentStreak,
            longestStreak: longestStreak
        )
    }
    
    private func calculateStreaks(_ sessions: [BedSession]) -> (current: Int, longest: Int) {
        let sortedSessions = sessions.sorted { $0.createdAt > $1.createdAt }
        var currentStreak = 0
        var longestStreak = 0
        var tempStreak = 0
        
        for session in sortedSessions {
            if session.metGoal {
                if currentStreak == 0 {
                    currentStreak = 1
                } else {
                    currentStreak += 1
                }
                tempStreak += 1
                longestStreak = max(longestStreak, tempStreak)
            } else {
                if currentStreak > 0 && tempStreak > 0 {
                    currentStreak = 0
                }
                tempStreak = 0
            }
        }
        
        return (currentStreak, longestStreak)
    }
}