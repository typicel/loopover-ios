//
//  InfoView.swift
//  Loopover
//
//  Created by Tyler McCormick on 6/10/24.
//

import SwiftUI

struct HowToPlayView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        VStack {
            Spacer()
            Text("Welcome to Loopover!")
                .font(.title)
                .bold()
            
            VStack(alignment: .leading) {
                Text("Loopover is a sliding block puzzle game where the goal is to restore each square to its original position. The rows and columns will \"loopover\" themselves, so be careful!")
                    .padding()
                
                Text("Tap scramble, and swipe rows or columns to move each piece back to its original place")
                    .padding()
                
                Text("Tap the size button on the top right of the board to change the board size")
                    .padding()

            }
            
            Spacer()
            
            Button("Dismiss") {
                dismiss()
            }
            .buttonStyle(.bordered)
            .buttonBorderShape(.roundedRectangle)
            .accessibilityLabel("Dismiss")
            
            Spacer()
        }
        .padding()
        
        
    }
}

#Preview {
    HowToPlayView()
}


