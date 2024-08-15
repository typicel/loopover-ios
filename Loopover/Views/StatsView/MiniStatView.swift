//
//  MiniStatsView.swift
//  Loopover
//
//  Created by Tyler McCormick on 7/19/24.
//

import SwiftUI

struct MiniStatView: View {
    
    let text: String
    let number: String
    
    init(text: String, number: String) {
        self.text = text
        self.number = number
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(text)
                .minimumScaleFactor(0.01)
            Text(number)
                .lineLimit(1)
                .font(.title)
                .bold()
                .minimumScaleFactor(0.01)
        }
    }
}

#Preview {
    MiniStatView(text: "Total Solves", number: "123")
}
