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
    @State private var gridSize = 5

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
    
    var scrambleTip = ScrambleTip()
    var swipeTip = SwipeTip()

    // PB
    @State private var personalBest: String? = UserDefaults.standard.string(forKey: "PB_5")
    
    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            
            // Top of Grid
            HStack(alignment: .bottom) {
                // PB Timer
                VStack(alignment: .leading) {
                    Text(self.board.formatTime(self.board.hundreths))
                        .font(.title)
                    
                    if let pb = self.personalBest {
                        Text("Personal Best: \(self.board.formatTime(Int(pb)!))")
                            .font(.subheadline)
                    } else {
                        Text("Personal Best: --:--:--")
                            .font(.subheadline)
                    }
                    
                } // VStack
                
                Spacer()
                
                // Grid Size Button
                Picker("", selection: self.$selectedSizeIdx) {
                    ForEach(Array(sizes.enumerated()), id: \.offset) { offset, size in
                        Text("\(size)x\(size)").tag(offset)
                    }
                }
                .pickerStyle(.automatic)
                .onChange(of: self.selectedSizeIdx) {
                    print("selected: \(self.selectedSizeIdx)")
                    self.gridSize = sizes[selectedSizeIdx]
                    
                    self.boxSize = availableSpace / CGFloat(self.gridSize)
                    self.board.resize(self.gridSize)
                    
                    self.board.stopTimer()
                    self.board.resetBoard()
                    self.gameStarted = false
                    self.freezeGestures = true
                    
                    self.personalBest = UserDefaults.standard.string(forKey: "\(self.gridSize)")
                }
                
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
//            .popoverTip(swipeTip, arrowEdge: .bottom)
            
            // Bottom of Grid
            HStack(alignment: .center){
                // Info Button
                Button("", systemImage: "gear", action: {self.showPopover = true})
                    .popover(isPresented: $showPopover, arrowEdge: .top){
                        GameInfoPopover()
                            .padding()
                            .frame(maxWidth: .infinity)
//                            .environmentObject(settings)
                    } // Button
                    .padding()
                
                Spacer()
                Text("\(board.numMoves) moves / \(String(format: "%.2f", self.board.getMps())) mps")
                    .font(.caption)
                    .foregroundStyle(.gray)
                Spacer()

                // Scramble Button
                Button("", systemImage: "arrow.triangle.2.circlepath") {
                    self.board.scramble()
                    self.resetBoard()
                    if self.doHaptics {
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    }
                    scrambleTip.invalidate(reason: .actionPerformed)
//                    SwipeTip.hasTappedScramble.toggle()
                }
                .padding()
//                .popoverTip(scrambleTip)
                
                
                
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
            
//            swipeTip.invalidate(reason: .actionPerformed)
//            BoardSizeTip.hasSwiped.toggle()
            
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
        self.board.resetBoard()
        self.gameStarted = false
        self.freezeGestures = false
    }
}

struct SwipeTip: Tip {
    
    @Parameter
    static var hasTappedScramble: Bool = false
    
    var rules: [Rule]  {
        [
            #Rule(Self.$hasTappedScramble) {
                $0 == true
            }
        ]
    }
    
    var title: Text {
        Text("How to Play")
    }

    var message: Text? {
        Text("Swipe to move a row or column. The tiles will loopover on themselves")
    }

    var image: Image? {
        Image(systemName: "questionmark")
    }

}

struct ScrambleTip: Tip {
    var title: Text {
        Text("How to Play")
    }

    var message: Text? {
        Text("Tap here to scramble the board")
    }

    var image: Image? {
        Image(systemName: "questionmark")
    }
}


#Preview {
    GameView()
        .task {
            try? Tips.resetDatastore()
            
            try? Tips.configure([
                .displayFrequency(.immediate),
                .datastoreLocation(.applicationDefault)
            ])
        }
}
