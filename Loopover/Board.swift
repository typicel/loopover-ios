//
//  Board.swift
//  Loopover
//
//  Created by Tyler McCormick on 3/2/24.
//

import Foundation

enum Axis {
    case Row
    case Col
}

struct Move {
    var axis: Axis
    var index: Int
    var n: Int
}

/**
 Data Model representing the loopover board. View should conform to this
 */
class Board: ObservableObject{
    @Published var board: [[Int]]
    @Published var seconds: Int
    private var timer: Timer?
    var rows: Int
    var cols: Int
    
    init(_ rows: Int, _ cols: Int) {
        self.rows = rows;
        self.cols = cols
        self.board = [[Int]]()
        self.seconds = 0
        self.timer = nil
        
        for i in 0..<self.rows {
            var row = [Int]()
            for j in 0..<self.cols {
                row.append(i * 5 + j + 1)
            }
            self.board.append(row)
        }
    }
    
    func startTimer() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.seconds += 1
        }
    }
    
    func move(_ move: Move) {
        if(move.axis == Axis.Col) {
            self.moveRow(index: move.index, n: move.n)
        } else {
            self.moveColumn(index: move.index, n: move.n)
        }
    }
    
    func moveRow(index: Int, n: Int) {
        let row = self.board[index]
        
        self.board[index] = row.enumerated().map { (i, element) in
            row[((i-n) % self.cols + self.cols) % self.cols]
        }
    }
    
    func moveColumn(index: Int, n: Int) {
        let col = (0..<self.rows).map( { i in self.board[i][index]})
        
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
    
    func printBoard() {
        for row in self.board {
            print(row)
        }
    }
}
