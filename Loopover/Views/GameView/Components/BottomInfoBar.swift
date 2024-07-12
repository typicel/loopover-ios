//
//  BottomInfoBar.swift
//  Loopover
//
//  Created by Tyler McCormick on 7/11/24.
//

import SwiftUI

struct BottomInfoBar: View {
    
    @EnvironmentObject var viewModel: GameViewModel
    
    var body: some View {
        HStack(alignment: .center){
            // Info Button
            Button("", systemImage: "gear", action: {viewModel.showPopover = true})
                .popover(isPresented: $viewModel.showPopover, arrowEdge: .top){
                    GameInfoPopover()
                        .padding()
                        .frame(maxWidth: .infinity)
                } // Button
                .padding()
            
            Spacer()
            Text("\(viewModel.numMoves) moves / \(String(format: "%.2f", viewModel.getMps())) mps")
                .font(.caption)
                .foregroundStyle(.gray)
            Spacer()
            
            // Scramble Button
            Button("", systemImage: "arrow.triangle.2.circlepath") {
                viewModel.board.scramble()
                viewModel.resetBoard()
                if viewModel.doHaptics {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                }
            }
            .padding()
        }
    }
}


#Preview {
    BottomInfoBar()
}
