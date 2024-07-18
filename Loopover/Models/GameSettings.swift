//
//  GameSettings.swift
//  Loopover
//
//  Created by Tyler McCormick on 5/19/24.
//

import Foundation

class GameSettings: ObservableObject {
    var availableSizes: [Int] = [3, 4, 5, 6, 7]
    @Published var gridSize: Int
    @Published var showNumbersOnly: Bool
    @Published var doConfettiEffects: Bool
    @Published var doHaptics: Bool
    
    init() {
        if let showNums = UserDefaults.standard.string(forKey: "showNumbersOnly") {
            self.showNumbersOnly = showNums == "true" ? true : false
        } else {
            self.showNumbersOnly = false
        }
        
        if let confetti = UserDefaults.standard.string(forKey: "doConfettiEffects") {
            self.doConfettiEffects = confetti == "true" ? true : false
        } else {
            self.doConfettiEffects = true
        }
        
        if let haptics = UserDefaults.standard.string(forKey: "doHaptics") {
            self.doHaptics = haptics == "true" ? true : false
        } else {
            self.doHaptics = true
        }

        self.gridSize = 5
    }
}
