//
//  ContentView.swift
//  Loopover
//
//  Created by Tyler McCormick on 3/2/24.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var board = Board(5,5)
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)

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
        .padding()
    }
}

#Preview {
    ContentView()
}
