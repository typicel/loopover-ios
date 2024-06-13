//
//  GameView.swift
//  Loopover
//
//  Created by Tyler McCormick on 5/19/24.
//

import SwiftUI
import ConfettiSwiftUI
import TipKit

let letters = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ")

struct GameView: View {
    
    @StateObject var board = Board(5, 5)
    
    @AppStorage("showNumbersOnly") var showNumbersOnly = false
    @AppStorage("doConfettiEffects") var doConfettiEffects = true
    @AppStorage("doHaptics") var doHaptics = true
    @AppStorage("gridSize") var gridSize = 5

    // Dragging
    @State private var availableSpace: CGFloat = 393.0 // These get overwritten immedieatly
    @State private var boxSize: CGFloat = 393.0/5.0
    @State private var isDragging = false
    @State private var startPos: (i: Int, j: Int)? = nil
    @State private var availableSize: CGSize? = nil
    @State private var showPopover = false
    @State private var freezeGestures = true
    
    @State private var gameStarted = false
    
    // Num rows/cols
    private let sizes = [3, 4, 5, 6, 7]
    @State private var selectedSizeIdx = 2
    
    // Confetti and Haptics
    @State private var confettiCounter = 0
    @State private var haptics = GameHaptics()
    
    var tip = ScrambleTip()
    
    // PB
    @State private var personalBest: String? = UserDefaults.standard.string(forKey: "PB_5")
    
    var body: some View {
        VStack {
            Spacer()
            
            // Top of Grid
            HStack(alignment: .bottom) {
                // PB Timer
                VStack {
                    Text(self.board.formatTime(self.board.hundreths))
                        .font(.title)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    if let pb = self.personalBest {
                        Text("Personal Best: \(self.board.formatTime(Int(pb)!))")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.caption)
                    } else {
                        Text("Personal Best: --:--:--")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.caption)
                    }
                } // VStack
                
                Spacer()
                
                // Grid Size Button
                Button("\(self.gridSize)x\(self.gridSize)") {
                    selectedSizeIdx = (selectedSizeIdx + 1) % sizes.count
                    self.gridSize = sizes[selectedSizeIdx]
                    
                    self.boxSize = availableSpace / CGFloat(self.gridSize)
                    self.board.resize(self.gridSize)
                    self.resetBoard()
                    
                    self.personalBest = UserDefaults.standard.string(forKey: "\(self.gridSize)")
                } // Button
//                .frame(alignment: .bottom)
//                .buttonStyle(.bordered)
                
            } // HStack
            
            LazyVGrid(columns: Array(repeating: GridItem(), count: self.board.cols), spacing: -1) {
                ForEach(0..<self.board.rows * self.board.cols, id: \.self) { index in
                    let el = self.board.board[index / self.board.cols][index % self.board.cols]
                    if (self.gridSize <= 5 && self.showNumbersOnly == false){
                        Box(text: String(letters[el.num]), size: boxSize, color: el.color)
                    } // endif
                    else {
                        Box(text: String(el.num+1), size: boxSize, color: el.color)
                    }
                } // ForEach
            } // LazyVGrid
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
                    Color.clear.onAppear {
                        self.availableSpace = reader.size.width + 10.0
                        self.boxSize = availableSpace / CGFloat(self.gridSize)
                        self.board.resize(self.gridSize)
                    } // onAppear
                } // GeometryReader
            )
            
            // Bottom of Grid
            HStack{
                // Info Button
                Button("", systemImage: "gear", action: {self.showPopover = true})
                    .popover(isPresented: $showPopover, arrowEdge: .top){
                        GameInfoPopover()
                            .padding()
                            .frame(maxWidth: .infinity)
//                            .environmentObject(settings)
                    } // Button
                    .padding()
                
                TipView(tip, arrowEdge: .trailing)
                Spacer()

                // Scramble Button
                Button("", systemImage: "arrow.triangle.2.circlepath") {
                    self.board.scramble()
                    self.resetBoard()
                    if self.doHaptics {
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    }
                }.padding()
                
                
            } // HStack
            Spacer()
            
        }
        .padding()
        .frame(maxWidth: .infinity)
        .confettiCannon(counter: $confettiCounter, num: 100, openingAngle: Angle(degrees: 0), closingAngle: Angle(degrees: 360), radius: 200)
    }

    func performMove(_ oi: Int, _ oj: Int, _ i: Int, _ j: Int) {
        if (oi, oj) != (i, j) {
            let axis = oi != i ? Axis.Row : Axis.Col
            let index = axis == Axis.Row ? oj : oi
            let n = axis == Axis.Row ? i - oi : j - oj
            
            guard index >= 0 && index < self.board.rows else { return }
            
            board.move(Move(axis: axis, index: index, n: n))
            
            if self.doHaptics {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
            }
            
            startPos = (i, j)
            if(!gameStarted) {
                self.gameStarted = true
                self.board.startTimer()
            }
            
            if(board.isSolved() && self.board.hundreths > 0) {
                self.freezeGestures = true
                self.board.stopTimer()
                
                if self.doConfettiEffects {
                    confettiCounter += 1
                }
                
                if self.doHaptics {
                    haptics.complexSuccess()
                }
                
                if let pb = UserDefaults.standard.string(forKey: "\(self.gridSize)") {
                    if self.board.hundreths < Int(pb)! {
                        UserDefaults.standard.set(self.board.hundreths, forKey: "\(self.gridSize)")
                    }
                } else {
                    UserDefaults.standard.set(self.board.hundreths, forKey: "\(self.gridSize)")
                }
                self.personalBest = UserDefaults.standard.string(forKey: "\(self.gridSize)")
            }
        }
    }
    
    func detectDrag(_ gesture: DragGesture.Value) {
        if freezeGestures == true { return }
        let location = gesture.location
        let i = Int(location.y / self.boxSize)
        let j = Int(location.x / self.boxSize)
        
        if !isDragging {
            isDragging = true
            startPos = (i, j)
        } else {
            if let (oi, oj) = startPos {
                performMove(oi, oj, i, j)
            }
        }
    }
    
    func resetBoard() {
        self.board.stopTimer()
        self.board.resetTimer()
        self.gameStarted = false
        self.freezeGestures = false
    }
}

struct ScrambleTip: Tip {
    var title: Text {
        Text("Scramble")
    }


    var message: Text? {
        Text("Tap here to scramble the board")
    }


    var image: Image? {
        return nil
    }
}


#Preview {
    GameView()
}
