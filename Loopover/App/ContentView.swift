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
    @State private var selectedTab = 0
    
    let titles = ["", "Stats", "Settings"]
    
    var body: some View {
        TabView(selection: $selectedTab) {
            GameView()
                .sheet(isPresented: $firstTime) {
                    HowToPlayView()
                }
                .tabItem {
                    Image(systemName: "square.grid.3x3.fill")
                    Text("Play")
                }
                .tag(0)

            StatsView()
                .tabItem {
                    Image(systemName: "chart.bar.fill")
                    Text("Stats")
                }
                .tag(1)

            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
                .tag(2)
            
        }
    }
}

#Preview {
    ContentView()
}

