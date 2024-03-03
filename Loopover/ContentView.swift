//
//  ContentView.swift
//  Loopover
//
//  Created by Tyler McCormick on 3/2/24.
//

import ConfettiSwiftUI
import SwiftUI

struct ContentView: View {
    private let letters = Array("ABCDEFGHJIKLMNOPQRSTUVWXYZ")
    private let sizes = [3, 4, 5]
    
    @StateObject var board = Board(5, 5)
    
    // Dragging
    @State private var availableSpace: CGFloat = 393.0
    @State private var boxSize: CGFloat = 393.0/5.0
    @State private var isDragging = false
    @State private var startPos: (i: Int, j: Int)? = nil
    @State private var availableSize: CGSize? = nil
    @State private var showPopover = false

    
    // Num rows/cols
    @State private var gridSize = 5
    @State private var selectedSize = 2
    
    // Confetti
    @State private var confettiCounter = 0
    
    func performMove(_ oi: Int, _ oj: Int, _ i: Int, _ j: Int) {
        if (oi, oj) != (i, j) {
            let axis = oi != i ? Axis.Row : Axis.Col
            let index = axis == Axis.Row ? oj : oi
            let n = axis == Axis.Row ? i - oi : j - oj
            
            guard index >= 0 && index < self.board.rows else { return }
            
            board.move(Move(axis: axis, index: index, n: n))
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            startPos = (i, j)
            
            if(board.isSolved()) {
                self.board.stopTimer()
                confettiCounter += 1
            }
        }
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
                performMove(oi, oj, i, j)
            }
        }
    }
    
    var body: some View {
        VStack {
            Text("Loopover")
                .font(.system(size: 48, weight: .heavy))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
            HStack {
                Text(self.board.formatTime(self.board.hundreths))
                    .font(.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Button("\(gridSize)x\(gridSize)") {
                    selectedSize = (selectedSize + 1) % 3
                    gridSize = sizes[selectedSize]
                    self.boxSize = availableSpace / CGFloat(gridSize)
                    print(boxSize)
                    self.board.resize(gridSize)
                }
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(), count: board.cols), spacing: -1) {
                ForEach(0..<board.rows * board.cols, id: \.self) { index in
                    let el = self.board.board[index / board.cols][index % board.cols]
                    Box(text: String(self.letters[el.num]), size: boxSize, color: el.color)
                }
            }
            .gesture(
                DragGesture(minimumDistance: 0.1)
                    .onChanged { gesture in
                        self.detectDrag(gesture)
                    }
                    .onEnded { _ in
                        self.isDragging = false
                        self.startPos = nil
                    }
            )
            .background( // to get the grid width
                GeometryReader { reader in
                    Color.red.onAppear{
                        self.availableSpace = reader.size.width + 10.0
                        self.boxSize = availableSpace / CGFloat(gridSize)
                        print(boxSize)
                        self.board.resize(gridSize)
                    }}
            )
            HStack{
                Button("", systemImage: "arrow.triangle.2.circlepath") {
                    board.scramble()
                    board.startTimer()
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                }
                Spacer()
                Button(action: {self.showPopover = true}) {
                    Text("Show Game Info")
                }
            }
            Spacer()

        }
        .padding()
        .frame(maxWidth: .infinity)
        .confettiCannon(counter: $confettiCounter, num: 100, openingAngle: Angle(degrees: 0), closingAngle: Angle(degrees: 360), radius: 200)
        .popover(isPresented: $showPopover, arrowEdge: .top) {
            GameInfoPopover()
                .padding()
                .frame(maxWidth: .infinity)
        }
    }
}


#Preview {
    ContentView()
}
