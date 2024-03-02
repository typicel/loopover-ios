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
    @State private var lastTouched: (i: Int, j: Int)? = nil
    
    func formatTime(_ time: Int) -> String{
        let minutes = self.board.seconds / 60
        let seconds = self.board.seconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    func detectDrag(i: Int, j: Int, gesture: DragGesture.Value) {
        let location = gesture.location
        let gridSize = CGSize(width: 75, height: 75) // Adjust based on your grid cell size

        let iIndex = Int(location.y / gridSize.height)
        let jIndex = Int(location.x / gridSize.width)
        
        print("Start: (\(i), \(j))")
        
        guard iIndex >= 0 && iIndex < self.board.rows && jIndex >= 0 && jIndex < self.board.cols else { return }

        print("Dragged from (\(i), \(j)) to (\(iIndex), \(jIndex))")
    }
    
    var body: some View {
        VStack {
            Spacer()
            Text(formatTime(self.board.seconds))
                .font(.title)
                .frame(maxWidth: .infinity, alignment: .leading)
            
                LazyVGrid(columns: Array(repeating: GridItem(), count: board.cols), spacing: 0) {
                        ForEach(0..<board.rows * board.cols, id: \.self) { index in
                            Text("\(board.board[index / board.cols][index % board.cols])")
                                .font(.title)
                                .bold()
                                .frame(width: 75, height: 75)
                                .border(Color.white)
                                .foregroundColor(.white)
                                .gesture(
                                    DragGesture(minimumDistance: 0.1)
                                        .onChanged { gesture in
                                            self.detectDrag(i: index/board.cols, j: index % board.cols, gesture: gesture)}
                                        .onEnded { _ in
                                            print("drag done")
                                            self.lastTouched = nil
                                        }
                                )
                        }
                }
            Spacer()
            Button(action: {board.scramble(); board.startTimer()}) {
                Image(systemName: "arrow.triangle.2.circlepath")
                    .padding()
                    .font(.title)
                    .foregroundColor(.teal)
            }
            .background(Color.white)
            .cornerRadius(10)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(cTeal))
    }
    
}


#Preview {
    ContentView()
}
