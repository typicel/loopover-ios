//
//  SwiftUIView.swift
//  Loopover
//
//  Created by Noah Tabori on 3/3/24.
//

import SwiftUI

struct GameInfoPopover: View {
    @EnvironmentObject var settings: GameSettings
    
    var body: some View {
        VStack {
            Spacer()
            Text("Welcome to Loopover!")
                .font(.system(size: 24))
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                
            Text("Loopover is a challenging sliding block puzzle game, where the goal is the restore the blocks to their original position. The rows and columns will \"loopover\" themselves , so be careful!")
                .padding()
                .frame(alignment: .leading)
            
            Text("Tap scramble, and swipe rows or columns to move each piece back to its original place")
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("Tap the size button on the top right of the board to change the board size")
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
            Spacer()
            
//            Picker("Grid Size", selection: $settings.gridSize) {
//                ForEach(settings.availableSizes, id: \.self) { size in
//                    Text("\(size)x\(size)").tag(size)
//                }
//            }
//            .pickerStyle(.segmented)
//            .padding()
            
            Picker("", selection: $settings.showNumbersOnly) {
                Text("Letters").tag(false)
                Text("Numbers").tag(true)
            }
            .pickerStyle(.segmented)
            .padding()
            .onChange(of: settings.showNumbersOnly) {
                UserDefaults.standard.setValue(settings.showNumbersOnly, forKey: "showNumbersOnly")
            }
            

            Spacer()
            
            Text("Remake of carykh's [Loopover](https://openprocessing.org/sketch/580366/)")
            Text("Developed by [tyler](https://github.com/typicel) and [noah](https://github.com/nota5633)")
        }
    }
}

#Preview {
    GameInfoPopover()
        .environmentObject(GameSettings())
}
