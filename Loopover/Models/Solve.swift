//
//  Solve.swift
//  Loopover
//
//  Created by Tyler McCormick on 7/11/24.
//

import Foundation
import SwiftData

/// Holds data pertaining to a user's solve stats for a single game
@Model
class Solve {
    var gameTime: Date
    var timeInHundreths: Int
    var numMoves: Int
    var gridSize: Int
    var averageMovesPerSecond: Double
    
    init(timeInHundreths: Int, numMoves: Int, averageMovesPerSecond: Double, gridSize: Int, gameTime: Date = .now) {
        self.gameTime = gameTime
        self.timeInHundreths = timeInHundreths
        self.numMoves = numMoves
        self.averageMovesPerSecond = averageMovesPerSecond
        self.gridSize = gridSize
    }
    
}
