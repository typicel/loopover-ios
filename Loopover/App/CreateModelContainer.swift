//
//  CreateModelContainer.swift
//  Loopover
//
//  Created by Tyler McCormick on 7/11/24.
//

import Foundation
import SwiftData

func generateRandomSolve(for gridSize: Int) {
    let timeInHundreths = Int.random(in: 1000*gridSize...10000*gridSize) // Random time between 10 and 100 seconds
    let numMoves = Int.random(in: 10*gridSize...(gridSize * 20)) // Random number of moves
    let averageMovesPerSecond = Double(numMoves) / (Double(timeInHundreths) / 100.0)
    
    // Generate a random date within the last 1-2 days
    let now = Date()
    let oneDayInSeconds: TimeInterval = 24 * 60 * 60
    let randomTimeInterval = TimeInterval.random(in: -2 * oneDayInSeconds...0)
    let randomDate = now.addingTimeInterval(randomTimeInterval)
        
    SolveStorageManager.shared.insertNewSolve(gameTime: randomDate, timeInHundreths: Int64(timeInHundreths), numMoves: Int64(numMoves), gridSize: Int16(gridSize), averageMovesPerSecond: averageMovesPerSecond, movesMade: [])

}

