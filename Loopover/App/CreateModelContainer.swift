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
    
//    return Solve(timeInHundreths: timeInHundreths, numMoves: numMoves, averageMovesPerSecond: averageMovesPerSecond, gridSize: gridSize, movesMade: [], gameTime: randomDate)
}

//func insertIntoDatabase(_ solves: [Solve], in context: ModelContext) {
//    for solve in solves {
//        context.insert(solve)
//    }
//}

//func createModelContext() -> ModelContext {
//    do {
//        let config = ModelConfiguration(for: Solve.self, isStoredInMemoryOnly: false)
//        let container = try ModelContainer(for: Solve.self, configurations: config)
//        
//        let context = ModelContext(container)
//        context.autosaveEnabled = true
//        
//#if DEBUG
//        print("adding fake solves")
//        var debugData3 = [Solve]()
//        var debugData4 = [Solve]()
//        var debugData5 = [Solve]()
//        var debugData6 = [Solve]()
//        var debugData7 = [Solve]()
//        
//        for _ in 1...Int.random(in: 10...15) {
//            debugData3.append(generateRandomSolve(for: 3))
//            debugData4.append(generateRandomSolve(for: 4))
//            debugData5.append(generateRandomSolve(for: 5))
//            debugData6.append(generateRandomSolve(for: 6))
//            debugData7.append(generateRandomSolve(for: 7))
//        }
//        
//        // delete all from context
//        try context.delete(model: Solve.self)
//        
//        insertIntoDatabase(debugData3, in: context)
//        insertIntoDatabase(debugData4, in: context)
//        insertIntoDatabase(debugData5, in: context)
//        insertIntoDatabase(debugData6, in: context)
//        insertIntoDatabase(debugData7, in: context)
//        
//        try context.save()
//        
//#endif
//        return context
//    } catch {
//        fatalError("Failed to initialize model container")
//    }
//}
