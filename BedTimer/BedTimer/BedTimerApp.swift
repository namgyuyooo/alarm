//
//  BedTimerApp.swift
//  BedTimer
//
//  Created by 유남규 on 9/21/25.
//

import SwiftUI
import SwiftData

@main
struct BedTimerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: BedSession.self)
    }
}
