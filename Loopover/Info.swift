//
//  SwiftUIView.swift
//  Loopover
//
//  Created by Noah Tabori on 3/3/24.
//

import SwiftUI

struct GameInfoPopover: View {
    let enzo = "[enzo](https://github.com/typicel)"
    let noah = "[noah](https://github.com/nota5633)"
    var body: some View {
        VStack {
            Spacer()
            Text("Welcome to Loopover!")
                .font(.system(size: 24))
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                
            Text("Loopover is a challenging 2D Rubix Cube style puzzle game, where the goal is the restore the blocks to their original position")
                .padding()
                .frame(alignment: .leading)
            Text("Tap scramble, and swipe rows or columns to move each piece back to its original place")
                .padding()
                .frame(alignment: .leading)
            Text("Tap the size button on the top right of the board to change the board size")
                .padding()
                .frame(alignment: .leading)
            Spacer()
            Text("Remake of carykh's [Loopover](https://openprocessing.org/sketch/580366/)")
            Text("Developed by [tyler](https://github.com/typicel) and [noah](https://github.com/nota5633)")
        }
    }
}

#Preview {
    GameInfoPopover()
}
