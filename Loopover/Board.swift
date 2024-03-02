//
//  Board.swift
//  Loopover
//
//  Created by Tyler McCormick on 3/2/24.
//

import Foundation

/**
 Data Model representing the loopover board. View should conform to this
 */
class Board: ObservableObject{
    @Published var board: [[Int]]
    var rows: Int
    var cols: Int
    
    init(_ rows: Int, _ cols: Int) {
        self.rows = rows;
        self.cols = cols
        self.board = [[Int]]()
        
        for i in 0..<self.rows {
            var row = [Int]()
            for j in 0..<self.cols {
                row.append(i * 5 + j)
            }
            self.board.append(row)
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
    
    func printBoard() {
        for row in self.board {
            print(row)
        }
    }
}
