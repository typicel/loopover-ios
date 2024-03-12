//
//  ContentView.swift
//  Loopover
//
//  Created by Tyler McCormick on 3/2/24.
//

import ConfettiSwiftUI
import CoreHaptics
import SwiftUI

let letters = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ")

class GameSettings: ObservableObject {
    var availableSizes: [Int] = [3, 4, 5, 6, 7]
    @Published var gridSize: Int
    @Published var showNumbersOnly: Bool
    
    init() {
        if let showNums = UserDefaults.standard.string(forKey: "showNumbersOnly") {
            self.showNumbersOnly = showNums == "true" ? true : false
        } else {
            self.showNumbersOnly = false
        }
        
        self.gridSize = 5
    }
}

struct ContentView: View {
    
    @StateObject var board = Board(5, 5)
    @StateObject var settings: GameSettings = GameSettings()
    
    // Dragging
    @State private var availableSpace: CGFloat = 393.0
    @State private var boxSize: CGFloat = 393.0/5.0
    @State private var isDragging = false
    @State private var startPos: (i: Int, j: Int)? = nil
    @State private var availableSize: CGSize? = nil
    @State private var showPopover = false
    @State private var freezeGestures = false
    
    @State private var gameStarted = false
    
    // Num rows/cols
    private let sizes = [3, 4, 5, 6, 7]
    @State private var selectedSizeIdx = 2
    
    // Confetti and Haptics
    @State private var confettiCounter = 0
    @State private var haptics = GameHaptics()
    
    // PB
    @State private var personalBest: String? = UserDefaults.standard.string(forKey: "5")
    
    func performMove(_ oi: Int, _ oj: Int, _ i: Int, _ j: Int) {
        if (oi, oj) != (i, j) {
            let axis = oi != i ? Axis.Row : Axis.Col
            let index = axis == Axis.Row ? oj : oi
            let n = axis == Axis.Row ? i - oi : j - oj
            
            guard index >= 0 && index < self.board.rows else { return }
            
            board.move(Move(axis: axis, index: index, n: n))
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            startPos = (i, j)
            if(!gameStarted) {
                self.gameStarted = true
                self.board.startTimer()
            }
            
            if(board.isSolved() && self.board.hundreths > 0) {
                self.freezeGestures = true
                self.board.stopTimer()
                confettiCounter += 1
                haptics.complexSuccess()
                
                if let pb = UserDefaults.standard.string(forKey: "\(settings.gridSize)") {
                    if self.board.hundreths < Int(pb)! {
                        UserDefaults.standard.set(self.board.hundreths, forKey: "\(settings.gridSize)")
                    }
                } else {
                    UserDefaults.standard.set(self.board.hundreths, forKey: "\(settings.gridSize)")
                }
                self.personalBest = UserDefaults.standard.string(forKey: "\(settings.gridSize)")
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
    
    var body: some View {
        VStack {
            Text("Loopover")
                .font(.system(size: 48, weight: .heavy))
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.primary)
            
            Spacer()
            
            HStack {
                VStack {
                    Text(self.board.formatTime(self.board.hundreths))
                        .font(.title)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    if let pb = personalBest {
                        Text("Personal Best: \(self.board.formatTime(Int(pb)!))")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.caption)
                    } else {
                        Text("Personal Best: --:--:--")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.caption)
                    }
                }
                
                Spacer()
                
                Button("\(settings.gridSize)x\(settings.gridSize)") {
                    selectedSizeIdx = (selectedSizeIdx + 1) % sizes.count
                    settings.gridSize = sizes[selectedSizeIdx]
                    
                    self.boxSize = availableSpace / CGFloat(settings.gridSize)
                    self.board.resize(settings.gridSize)
                    self.resetBoard()
                    
                    self.personalBest = UserDefaults.standard.string(forKey: "\(settings.gridSize)")
                }
                .frame(alignment: .bottom)
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(), count: board.cols), spacing: -1) {
                ForEach(0..<board.rows * board.cols, id: \.self) { index in
                    let el = self.board.board[index / board.cols][index % board.cols]
                    if (settings.gridSize <= 5 && settings.showNumbersOnly == false){
                        Box(text: String(letters[el.num]), size: boxSize, color: el.color)
                    }
                    else {
                        Box(text: String(el.num+1), size: boxSize, color: el.color)
                    }
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
                    Color.clear.onAppear {
                        self.availableSpace = reader.size.width + 10.0
                        self.boxSize = availableSpace / CGFloat(settings.gridSize)
                        self.board.resize(settings.gridSize)
                    }}
            )
            HStack{
                Button("", systemImage: "arrow.triangle.2.circlepath") {
                    board.scramble()
                    self.resetBoard()
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                }.padding()
                
                Spacer()
                
                Button("", systemImage: "info.circle", action: {self.showPopover = true})
                    .popover(isPresented: $showPopover, arrowEdge: .top){
                        GameInfoPopover()
                            .padding()
                            .frame(maxWidth: .infinity)
                            .environmentObject(settings)
                    }
                    .padding()
                
            }
            Spacer()

        }
        .padding()
        .frame(maxWidth: .infinity)
        .confettiCannon(counter: $confettiCounter, num: 100, openingAngle: Angle(degrees: 0), closingAngle: Angle(degrees: 360), radius: 200)
    }
}


#Preview {
    ContentView()
}
