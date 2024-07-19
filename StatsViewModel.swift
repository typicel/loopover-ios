//
//  StatsViewModel.swift
//  Loopover
//
//  Created by Tyler McCormick on 7/12/24.
//

import SwiftUI
import SwiftData

class StatsViewModel: ObservableObject {
    @Published var selectedPath: Int = 0
    @Published var solves: [Solve] = [Solve]()
    @Published var keyPath: KeyPath<Solve, Int> = \.numMoves
    
    var selectedKeyPath: KeyPath<Solve, Int> {
        Constants.chartKeyPaths[selectedPath]
    }
    
}
