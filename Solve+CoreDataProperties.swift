//
//  Solve+CoreDataProperties.swift
//  Loopover
//
//  Created by Tyler McCormick on 7/19/24.
//
//

import Foundation
import CoreData


extension Solve {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Solve> {
        return NSFetchRequest<Solve>(entityName: "Solve")
    }

    @NSManaged public var gameTime: Date?
    @NSManaged public var timeInHundreths: Int64
    @NSManaged public var numMoves: Int64
    @NSManaged public var gridSize: Int16
    @NSManaged public var averageMovesPerSecond: Double
    @NSManaged public var movesMade: [Move]!

}

extension Solve : Identifiable {

}
