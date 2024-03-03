//
//  SwiftUIView.swift
//  Loopover
//
//  Created by Noah Tabori on 3/3/24.
//

import SwiftUI

struct GameInfoPopover: View {
    var body: some View {
        VStack {
            Text("Welcome to Loopover!")
                .font(.headline)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .padding()
            
            Text("Press the Scramble button to start, then swipe along any Row or Column to shift it around the grid! The edges wrap around, so try not to get your head in a bunch solving for the original order. Good Luck!")
                .multilineTextAlignment(.center)
                .padding()
        }
    }
}
