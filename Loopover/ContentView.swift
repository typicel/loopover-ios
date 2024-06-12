//
//  ContentView.swift
//  Loopover
//
//  Created by Tyler McCormick on 3/2/24.
//

import SwiftUI
import TipKit

struct ContentView: View {
    
    @AppStorage("firstTime") var firstTime = true
    @Environment(\.dismiss) var dismiss
    
    @State private var isActive: Bool = true
    
    var body: some View {
        VStack {
            GameView()
                .task {
                    try? Tips.configure([
                        .displayFrequency(.immediate),
                        .datastoreLocation(.applicationDefault)
                    ])
                }
        }
        .sheet(isPresented: $firstTime) {
            HowToPlayView()
        }
    }
}


#Preview {
    ContentView()
}

