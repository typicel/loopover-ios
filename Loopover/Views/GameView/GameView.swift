//
//  GameView.swift
//  Loopover
//
//  Created by Tyler McCormick on 5/19/24.
//

import SwiftUI
import SwiftData
import ConfettiSwiftUI

struct GameView: View {
    
    @EnvironmentObject var viewModel: GameViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            
            TopInfoBar()
            GameBoardView()
            BottomInfoBar()
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    let modelContext = try! ModelContainer(for: Solve.self).mainContext
    GameView()
        .environmentObject(GameViewModel(modelContext: modelContext))
}
