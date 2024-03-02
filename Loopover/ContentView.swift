//
//  ContentView.swift
//  Loopover
//
//  Created by Tyler McCormick on 3/2/24.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var board = Board(5,5)
    
    @State private var offset = CGSize.zero
    @State private var isDragging = false
    
    
    func formatTime(_ time: Int) -> String{
        let minutes = self.board.seconds / 60
        let seconds = self.board.seconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    var body: some View {
        VStack {
            Text(formatTime(self.board.seconds))
            LazyVGrid(columns: Array(repeating: GridItem(), count: board.cols), spacing: 10) {
                ForEach(0..<board.rows * board.cols, id: \.self) { index in
                    Text("\(board.board[index / board.cols][index % board.cols])")
                        .frame(width: 50, height: 50)
                        .border(Color.black)
                }
            }
            
            Button("Scramble") {
                board.scramble()
            }
        }
        .onAppear{
            self.board.startTimer()
        }
        .padding()
    }
    
}

#Preview {
    ContentView()
}
