//
//  StatsViewModel.swift
//  Loopover
//
//  Created by Tyler McCormick on 7/12/24.
//

import SwiftUI
import SwiftData

enum ShownStat {
    case moves, time
}

class StatsViewModel: ObservableObject {
    @Published var solves: [Solve] = [Solve]()
    @Published var shownStat: ShownStat = .moves
    @Published var selectedGridSize: Int = 5
    @Published var allSolves: [Solve] = []
    
    @Published var didError: Bool = false
    @Published var error: Error? = nil
    @Published var alertMessage: String = ""
    
    var selectedKeyPath: KeyPath<Solve, Int64> {
        switch shownStat {
        case .moves:
            \.numMoves
        case .time:
            \.timeInHundreths
        }
    }
    
    var filteredSolves: [Solve] {
        return allSolves.compactMap { solve in
            solve.gridSize == selectedGridSize ? solve : nil
        }
    }
    
    func getAllSolves() {
        let result = SolveStorageManager.shared.getAllSolves()
        switch result {
        case .success(let solves):
            self.allSolves = solves
        case .failure(let error):
            self.error = error
            self.didError = true
        }
    }
    
    var bestStat: String {
        switch shownStat {
        case .moves:
            return bestMoves
        case .time:
            return bestSolveTime
        }
    }
    
    var averageStat: String {
        switch shownStat {
        case .moves:
            return averageMoves
        case .time:
            return averageSolveTime
        }
    }
    
    var medianStat: String {
        switch shownStat {
        case .moves:
            return medianMoves
        case .time:
            return medianSolveTime
        }
    }
    
    // MARK: - Best, Average, and Median Solve Times
    
    var averageSolveTime: String {
        guard filteredSolves.count > 0 else { return "--:--:--" }
        
        let total = filteredSolves.reduce(0) { result, solve in
            result + solve.timeInHundreths
        }
        
        let average = Double(total) / Double(filteredSolves.count)
        
        return Int(average).durationFormat()
    }
    
    var bestSolveTime: String {
        print("getting it for PB_\(selectedGridSize)")
        if let timeInHundreths = UserDefaults.standard.string(forKey: "PB_\(selectedGridSize)") {
            guard let time = Int(timeInHundreths) else { return "--:--:--" }
            return time.durationFormat()
        } else {
            return "--:--:--"
        }
    }
    
    var medianSolveTime: String {
        guard filteredSolves.count > 0 else { return "--:--:--" }
        
        let sortedSolves = filteredSolves.sorted { $0.timeInHundreths < $1.timeInHundreths }
        let middleIndex = sortedSolves.count / 2
        
        if sortedSolves.count.isMultiple(of: 2) {
            let first = sortedSolves[middleIndex - 1]
            let second = sortedSolves[middleIndex]
            let duration = Int((first.timeInHundreths + second.timeInHundreths)) / 2
            
            return duration.durationFormat()
        }
        
        return Int(sortedSolves[middleIndex].timeInHundreths).durationFormat()
    }
    
    // MARK: - Best, Average, and Median Moves
    
    var bestMoves: String {
        guard filteredSolves.count > 0 else { return "---" }
        
        let sortedSolves = filteredSolves.sorted { $0.numMoves < $1.numMoves }
        return String(sortedSolves[0].numMoves)
    }
    
    var averageMoves: String {
        guard filteredSolves.count > 0 else { return "---" }
        
        let sum: Int = filteredSolves.reduce(0) { $0 + Int($1.numMoves) }
        return String(sum / filteredSolves.count)
    }
    
    var medianMoves: String {
        guard filteredSolves.count > 0 else { return "---" }
        
        let sortedSolves = filteredSolves.sorted { $0.numMoves < $1.numMoves }
        let middleIndex = sortedSolves.count / 2
        
        if sortedSolves.count.isMultiple(of: 2) {
            let first = sortedSolves[middleIndex - 1]
            let second = sortedSolves[middleIndex]
            return String((first.numMoves + second.numMoves) / 2)
        }
        
        return String(sortedSolves[middleIndex].numMoves)
    }
    
    // MARK: - Average of last 5 Solves
    
    var averageLastFiveMoves: String {
        guard filteredSolves.count >= 5 else { return "---" }
        
        let lastFive: ArraySlice<Solve> = filteredSolves.sorted { $0.gameTime > $1.gameTime } .prefix(5)
        let sum = lastFive.reduce(0) { $0 + Int($1.numMoves) }
        
        return String(sum / 5)
    }
    
    var averageLastFiveTime: String {
        guard filteredSolves.count >= 5 else { return "---" }
        
        let lastFive: ArraySlice<Solve> = filteredSolves.sorted { $0.gameTime > $1.gameTime } .prefix(5)
        let sum = lastFive.reduce(0) { $0 + $1.timeInHundreths }
        
        return String(sum / 5)
    }
    
    func getLastFiveOrLess() -> [Solve] {
        guard filteredSolves.count > 0 else { return [] }
        
        let last = Array(filteredSolves.sorted { $0.gameTime > $1.gameTime }.prefix(5))
        return last
    }
}
