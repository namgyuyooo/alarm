import XCTest
@testable import BedTimerKit
import SwiftData

@MainActor
@available(iOS 17.0, macOS 14.0, *)
final class SessionRepositoryTests: XCTestCase {
    private var container: ModelContainer!
    private var context: ModelContext!
    private var repository: SessionRepository!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        container = try ModelContainer(
            for: BedSession.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        context = ModelContext(container)
        repository = SessionRepository(modelContext: context)
    }
    
    override func tearDownWithError() throws {
        container = nil
        context = nil
        repository = nil
        try super.tearDownWithError()
    }
    
    func testSaveAndFetchSession() async throws {
        let session = BedSession(
            scheduledAlarm: Date(),
            goalMinutes: 5
        )
        try await repository.save(session)
        let fetched = try await repository.fetchAll()
        XCTAssertEqual(fetched.count, 1)
        XCTAssertEqual(fetched.first?.id, session.id)
    }
    
    func testUpdateSessionPersistsChanges() async throws {
        let session = BedSession(
            scheduledAlarm: Date(),
            goalMinutes: 5
        )
        try await repository.save(session)
        session.start()
        try await repository.update(session)
        let reloaded = try await repository.fetchById(session.id)
        XCTAssertNotNil(reloaded?.acknowledgedAt)
    }
    
    func testDeleteSessionRemovesFromStore() async throws {
        let session = BedSession(
            scheduledAlarm: Date(),
            goalMinutes: 5
        )
        try await repository.save(session)
        try await repository.delete(session)
        let remaining = try await repository.fetchAll()
        XCTAssertTrue(remaining.isEmpty)
    }
    
    func testStatisticsReflectCompletedSessions() async throws {
        let completed = BedSession(
            scheduledAlarm: Date(),
            goalMinutes: 5
        )
        completed.start()
        completed.end()
        let inProgress = BedSession(
            scheduledAlarm: Date(),
            goalMinutes: 10
        )
        inProgress.start()
        try await repository.save(completed)
        try await repository.save(inProgress)
        let stats = try await repository.getStatistics()
        XCTAssertEqual(stats.totalSessions, 2)
        XCTAssertEqual(stats.completedSessions, 1)
        XCTAssertGreaterThanOrEqual(stats.goalSuccessRate, 0.0)
    }
}
