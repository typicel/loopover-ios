//
//  GameViewModel.swift
//  Loopover
//
//  Created by Tyler McCormick on 7/11/24.
//

import Foundation
import SwiftUI
import SwiftData

class GameViewModel: ObservableObject {
    
    @Published var board = Board(5, 5)
    @Environment(\.managedObjectContext) var modelContext
    
    // MARK - Game Configuration / Settings
    
    @AppStorage("showNumbersOnly") var showNumbersOnly = false
    @AppStorage("doConfettiEffects") var doConfettiEffects = true
    @AppStorage("doHaptics") var doHaptics = true
    @Published var gridSize = 5
    
    // MARK - Dragging Parameters
    
    @Published var availableSpace: CGFloat = 393.0 // These get overwritten immedieatly
    @Published var boxSize: CGFloat = 393.0/5.0
    @Published var isDragging = false
    @Published var startPos: (i: Int, j: Int)? = nil
    @Published var availableSize: CGSize? = nil
    @Published var showPopover = false
    @Published var freezeGestures = true
    @Published var gameStarted = false

    // Num rows/cols
    @Published var selectedSizeIdx = 2
    
    // Confetti and Haptics
    @Published var confettiCounter = 0
    @Published var haptics = GameHaptics()
    
    // PB
    @Published var personalBest: String? = UserDefaults.standard.string(forKey: "PB_5")
    
    private var timer: Timer? = nil
    @Published var hundreths: Int = 0
    @Published var numMoves: Int = 0
    private var movesMade: [Move] = []
    
    func calculateSpace(with reader: GeometryProxy) {
        availableSpace = reader.size.width + 10.0
        boxSize = availableSpace / CGFloat(gridSize)
        board.resize(gridSize)
    }

    func startTimer() {
        timer?.invalidate()
        self.hundreths = 0
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
            self.hundreths += 1
        }
    }
    
    func stopTimer() {
        self.timer?.invalidate()
        timer = nil
    }
    
    func elementForIndex(at index: Int) -> Element {
        self.board.board[index / self.board.cols][index % self.board.cols]
    }
    
    func saveGameStats() {
        SolveStorageManager.shared.insertNewSolve(gameTime: .now, timeInHundreths: Int64(hundreths), numMoves: Int64(numMoves), gridSize: Int16(gridSize), averageMovesPerSecond: self.getMps(), movesMade: self.movesMade)
    }
    
    // Get the moves per second at the current moment in time
    func getMps() -> Double {
        guard self.hundreths > 0 else { return 0 }
        
        let seconds: Double = Double(self.hundreths / 100)
        let mps = Double(self.numMoves) / seconds
        return mps
    }
    
    func performMove(_ oi: Int, _ oj: Int, _ i: Int, _ j: Int) {
        if (oi, oj) != (i, j) {
            let axis = oi != i ? Axis.Row : Axis.Col
            let index = axis == Axis.Row ? oj : oi
            let n = axis == Axis.Row ? i - oi : j - oj
            
            guard index >= 0 && index < self.board.rows else { return }
            
            let move = Move(axis: axis, index: index, n: n)
            board.move(move)
            self.numMoves += 1
            self.movesMade.append(move)
            
            if self.doHaptics {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
            }
            
            startPos = (i, j)
            if(!gameStarted) {
                self.gameStarted = true
                self.startTimer()
            }
            
            if(board.isSolved() && self.hundreths > 0) {
                self.freezeGestures = true
                self.stopTimer()
                
                if self.doConfettiEffects {
                    confettiCounter += 1
                }
                
                print(self.movesMade)

                Task {
                    if self.doHaptics {
                        haptics.complexSuccess()
                    }
                
                    self.saveGameStats()
                }
                
                if let pb = UserDefaults.standard.string(forKey: "PB_\(self.gridSize)") {
                    if self.hundreths < Int(pb)! {
                        UserDefaults.standard.set(self.hundreths, forKey: "PB_\(self.gridSize)")
                    }
                } else {
                    UserDefaults.standard.set(self.hundreths, forKey: "PB_\(self.gridSize)")
                }
                
                self.personalBest = UserDefaults.standard.string(forKey: "PB_\(self.gridSize)")
                print("insert time for PB_\(self.gridSize)")
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
        self.stopTimer()
        self.hundreths = 0
        self.numMoves = 0
        self.movesMade = []
        self.gameStarted = false
        self.freezeGestures = false
    }
    
    func resizeBoard() {
        self.gridSize = Constants.sizes[selectedSizeIdx]
        
        self.boxSize = availableSpace / CGFloat(self.gridSize)
        self.board.resize(self.gridSize)
        self.movesMade = []
        
        self.stopTimer()
        self.resetBoard()
        self.gameStarted = false
        self.freezeGestures = true
        
        self.personalBest = UserDefaults.standard.string(forKey: "\(self.gridSize)")
    }
    
}
