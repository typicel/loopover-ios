//
//  ContentView.swift
//  Loopover
//
//  Created by Tyler McCormick on 3/2/24.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var board = Board(5,5)
    private var boxSize: CGFloat = 75
    private let letters = Array("ABCDEFGHJIKLMNOPQRSTUVWXYZ")
    
    @State private var offset = CGSize.zero
    @State private var isDragging = false
    @State private var startPos: (i: Int, j: Int)? = nil
    
    func formatTime(_ time: Int) -> String{
        let minutes = self.board.hundreths / 6000
        let seconds = (self.board.hundreths / 100) % 60
        let hundreths = self.board.hundreths % 100
        return String(format: "%02d:%02d:%02d", minutes, seconds, hundreths)
    }
    
    func detectDrag(_ gesture: DragGesture.Value) {
        let location = gesture.location
        let i = Int(location.y / boxSize)
        let j = Int(location.x / boxSize)
        
        if !isDragging {
            isDragging = true
            startPos = (i, j)
        } else {
            if let (oi, oj) = startPos {
                if (oi, oj) != (i, j) {
                    
                    let axis = oi != i ? Axis.Row : Axis.Col
                    let index = axis == Axis.Row ? oj : oi
                    let n = axis == Axis.Row ? i - oi : j - oj
                    
                    guard index >= 0 && index < self.board.rows else { return }
                    
                    board.move(Move(axis: axis, index: index, n: n))
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    startPos = (i, j)
                }
            }
        }
    }
    
    var body: some View {
        VStack {
            Text("Loopover")
                .font(.title)
            Spacer()
            Text(formatTime(self.board.hundreths))
                .font(.title)
                .frame(maxWidth: .infinity, alignment: .leading)
            
                LazyVGrid(columns: Array(repeating: GridItem(), count: board.cols), spacing: 0) {
                    ForEach(0..<board.rows * board.cols, id: \.self) { index in
                        Box(text: String(self.letters[board.board[index / board.cols][index % board.cols]]), size: 75)
                    }
                }
                .gesture(
                    DragGesture(minimumDistance: 0.1)
                        .onChanged { gesture in
                            self.detectDrag(gesture)
                            offset = CGSize(width: gesture.translation.width, height: gesture.translation.height)
                        }
                        .onEnded { _ in
                            self.isDragging = false
                            self.startPos = nil
                        }
                )
            
            Spacer()
            
            Button("", systemImage: "arrow.triangle.2.circlepath") {
                board.scramble()
                board.startTimer()
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(cTeal))
    }
}


#Preview {
    ContentView()
}
