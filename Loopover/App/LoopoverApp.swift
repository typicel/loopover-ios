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
    
    @StateObject private var coreDataStack = SolveStorageManager.shared
    
    init() {
        SJParentValueTransformer<Move>.registerTransformer()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, coreDataStack.perrsistentContainer.viewContext)
        }
    }
}
