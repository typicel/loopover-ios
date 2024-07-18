//
//  ContentView.swift
//  Loopover
//
//  Created by Tyler McCormick on 3/2/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @Environment(\.modelContext) var context
    @AppStorage("firstTime") var firstTime: Bool = true
    
    var body: some View {
        GameView()
            .environmentObject(GameViewModel(modelContext: self.context))
            .sheet(isPresented: $firstTime) {
                HowToPlayView()
            }
    }
}

#Preview {
    ContentView()
}

