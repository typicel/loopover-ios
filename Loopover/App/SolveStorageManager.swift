//
//  CoreDataStack.swift
//  Loopover
//
//  Created by Tyler McCormick on 7/19/24.
//

import Foundation
import CoreData

class SolveStorageManager: ObservableObject {
    static let shared = SolveStorageManager()
    
    lazy var perrsistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Solve")
        
        container.loadPersistentStores { _, error in
            if let error {
                fatalError("Failed to load persistent stores: \(error.localizedDescription)")
            }
        }
        
        return container
    }()
    
    func saveChanges() {
        let context = perrsistentContainer.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Could not save changes to Core Data.", error.localizedDescription)
            }
        }
    }
    
    func insertNewSolve(
        gameTime: Date,
        timeInHundreths: Int64,
        numMoves: Int64,
        gridSize: Int16,
        averageMovesPerSecond: Double,
        movesMade: [Move]
    ) {
        let entity = Solve(context: perrsistentContainer.viewContext)
        
        entity.gameTime = gameTime
        entity.timeInHundreths = timeInHundreths
        entity.numMoves = numMoves
        entity.gridSize = gridSize
        entity.averageMovesPerSecond = averageMovesPerSecond
        entity.movesMade = movesMade
        
        do {
            try perrsistentContainer.viewContext.save()
            print("Saved")
        } catch {
            print("Failed to save changes to Core Data.", error.localizedDescription)
        }
    }
    
    func getAllSolves() -> [Solve] {
        let context = perrsistentContainer.viewContext
        let request: NSFetchRequest<Solve> = Solve.fetchRequest()
        
        var results: [Solve] = []
        
        do {
            results = try context.fetch(request)
        } catch {
            print("Could not fetch solves from Core Data.", error.localizedDescription)
        }
        
        print("results in data stack: \(results)")
        return results
    }
    
    private init() {}
}
