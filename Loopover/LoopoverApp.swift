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
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContext(createModelContext())
        }
    }
}
