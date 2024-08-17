//
//  Int+DurationFormat.swift
//  Loopover
//
//  Created by Tyler McCormick on 8/15/24.
//

import Foundation

extension Int {
    func durationFormat() -> String {
        return self.formatted(TimeFormatStyle())
    }
}

struct TimeFormatStyle: FormatStyle {
    typealias FormatInput = Int
    typealias FormatOutput = String
    
    func format(_ value: Int) -> String {
        let minutes = value / 6000
        let seconds = (value % 6000) / 100
        let hundredths = (value % 100)
        
        return String(format: "%02d:%02d.%02d", minutes, seconds, hundredths)
    }
}
