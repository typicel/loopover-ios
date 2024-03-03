//
//  Board.swift
//  Loopover
//
//  Created by Tyler McCormick on 3/2/24.
//

import Foundation
import SwiftUI

enum Axis {
    case Row
    case Col
}

struct Move {
    var axis: Axis
    var index: Int
    var n: Int
}

struct Element {
    var num: Int
    var color: Color
}

/**
 Data Model representing the loopover board. View should conform to this
 */
class Board: ObservableObject{
    @Published var board: [[Element]]
    @Published var hundreths: Int
    private var timer: Timer?
    var rows: Int
    var cols: Int
    
    init(_ rows: Int, _ cols: Int) {
        self.rows = rows;
        self.cols = cols
        self.board = [[Element]]()
        self.hundreths = 0
        self.timer = nil
        
        self.createBoard(rows, cols)
    }
    
    private func createBoard(_ rows: Int, _ cols: Int) {
        let dc = Double(self.cols)
        let dr = Double(self.rows)
        
        for i in 0..<self.rows {
            var row = [Element]()
            for j in 0..<self.cols {
                let val: Double = Double(i * self.rows + j)
                
                let cx: Double = (val.truncatingRemainder(dividingBy: dc)) / (dc - 1.0)
                let cy: Double = (val / dc) / (dr - 1.0)
                
                row.append(Element(num: Int(val), color: Color(red: 1.0-cx, green: cy, blue: cx)))
            }
            self.board.append(row)
        }
    }
    
    func resize(_ size: Int) {
        self.rows = size
        self.cols = size
        self.board = [[Element]]()
        self.createBoard(size, size)
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
    
    func resetTimer() {
        self.hundreths = 0
    }
       
    func formatTime(_ time: Int) -> String{
        let minutes = self.hundreths / 6000
        let seconds = (self.hundreths / 100) % 60
        let hundreths = self.hundreths % 100
        return String(format: "%02d:%02d:%02d", minutes, seconds, hundreths)
    }
    
    func move(_ move: Move) {
        if(move.axis == Axis.Col) {
            self.moveRow(index: move.index, n: move.n)
        } else {
            self.moveColumn(index: move.index, n: move.n)
        }
    }
    
    private func moveRow(index: Int, n: Int) {
        let row = self.board[index]
        
        self.board[index] = row.enumerated().map { (i, element) in
            row[((i - n) % self.cols + self.cols) % self.cols]
        }
    }
    
    private func moveColumn(index: Int, n: Int) {
        let col = (0..<self.rows).map { i in self.board[i][index]}
        
        for i in 0..<self.rows {
            self.board[i][index] = col[((i-n) % self.rows + self.rows) % self.rows]
        }
    }
    
    func scramble() {
        for _ in 0...self.rows * self.cols + 50 {
            let axis = Int.random(in: 1...100) >= 50 ? Axis.Col : Axis.Row
            let n = Int.random(in: 1...100)
            let index = axis == Axis.Col ? Int.random(in: 0..<self.cols) : Int.random(in: 0..<self.rows)
           
            self.move(Move(axis: axis, index: index, n: n))
        }
    }
    
    func isSolved() -> Bool{
        for i in 0..<self.rows * self.cols {
            if self.board[i/self.cols][i%self.cols].num != i {
                return false
            }
        }
        return true
    }
    
    func printBoard() {
        for row in self.board {
            print(row)
        }
    }
}
