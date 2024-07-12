//
//  LoopoverApp.swift
//  Loopover
//
//  Created by Tyler McCormick on 3/2/24.
//

import SwiftUI
import SwiftData

@main
struct LoopoverApp: App {
    
    let container: ModelContainer
    
    init() {
        do {
            self.container = try ModelContainer(for: Solve.self)
        } catch {
            fatalError("Failed to initialize model container")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(self.container)
        }
    }
}
