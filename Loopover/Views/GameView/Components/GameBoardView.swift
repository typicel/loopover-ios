//
//  GameBoardView.swift
//  Loopover
//
//  Created by Tyler McCormick on 7/11/24.
//

import SwiftUI
import ConfettiSwiftUI

struct GameBoardView: View {
    
    @EnvironmentObject var viewModel: GameViewModel
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(), count: viewModel.board.cols), spacing: -1) {
            ForEach(0..<viewModel.board.totalElemens, id: \.self) { index in
                let el = viewModel.elementForIndex(at: index)
                
                if (viewModel.gridSize <= 5 && viewModel.showNumbersOnly == false){
                    Box(text: String(Constants.letters[el.num]), size: viewModel.boxSize, color: el.color)
                }
                else {
                    Box(text: String(el.num+1), size: viewModel.boxSize, color: el.color)
                }
            }
        }
        .gesture(customDrag)
        .background(
            GeometryReader { reader in
                Color.clear.onAppear {
                    viewModel.calculateSpace(with: reader)
                }
            }
        )
        .confettiCannon(counter: $viewModel.confettiCounter, num: 100, openingAngle: Angle(degrees: 0), closingAngle: Angle(degrees: 360), radius: 200)
    }
    
    var customDrag: some Gesture {
        DragGesture(minimumDistance: 0.1)
            .onChanged { gesture in
                viewModel.detectDrag(gesture)
            }
            .onEnded { _ in
                viewModel.isDragging = false
                viewModel.startPos = nil
            }
    }
    
}

#Preview {
    GameBoardView()
}
