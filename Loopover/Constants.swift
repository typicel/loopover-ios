//
//  Constants.swift
//  Loopover
//
//  Created by Tyler McCormick on 7/11/24.
//

import Foundation

struct Constants {
    static let letters = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ")
    static let chartKeyPaths: [KeyPath<Solve, Int>] = [\.numMoves, \.timeInHundreths]
    static let sizes = [3, 4, 5, 6, 7]
}
