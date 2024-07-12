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
    
    var body: some View {
        TabView {
            GameView()
                .environmentObject(GameViewModel(modelContext: self.context))
                .tabItem {
                    Image(systemName: "gamecontroller")
                    Text("Game")
                }
            
            StatsView()
                .tabItem {
                    Image(systemName: "chart.bar.fill")
                    Text("Stats")
                }
        }
    }
}


#Preview {
    ContentView()
}

