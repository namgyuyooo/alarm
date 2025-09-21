import SwiftUI
import SwiftData
import BedTimerKit

@main
struct BedTimerApp: App {
    private let modelContainer: ModelContainer = {
        do {
            return try ModelContainer(for: BedSession.self)
        } catch {
            fatalError("Failed to create ModelContainer: \(error.localizedDescription)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .modelContainer(modelContainer)
        }
    }
}
