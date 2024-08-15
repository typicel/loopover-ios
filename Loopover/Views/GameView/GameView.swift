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
    @StateObject var viewModel =  GameViewModel()
    
    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            
            TopInfoBar()
            GameBoardView()
            BottomInfoBar()
            
            Spacer()
        }
        .padding()
        .environmentObject(viewModel)
        
    }
}

#Preview("Game") {
    GameView()
}
