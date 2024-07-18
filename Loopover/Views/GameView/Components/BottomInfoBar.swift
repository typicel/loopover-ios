//
//  BottomInfoBar.swift
//  Loopover
//
//  Created by Tyler McCormick on 7/11/24.
//

import SwiftUI
import SwiftData

struct BottomInfoBar: View {
    
    @EnvironmentObject var viewModel: GameViewModel
    
    var body: some View {
        HStack(alignment: .center){
            
            // Info Button
            Button("", systemImage: "gear", action: {viewModel.showPopover = true})
                .sheet(isPresented: $viewModel.showPopover){
                    GameInfoPopover()
                }
            
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
    let modelContext = try! ModelContainer(for: Solve.self).mainContext
    BottomInfoBar()
        .environmentObject(GameViewModel(modelContext: modelContext))
}
