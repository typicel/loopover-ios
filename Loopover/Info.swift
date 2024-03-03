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
            Text("How to Play Your Game")
                .font(.headline)
                .padding()
            
            Text("Insert instructions and information about your game here.")
                .multilineTextAlignment(.center)
                .padding()
        }
    }
}
