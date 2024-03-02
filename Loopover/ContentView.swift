//
//  ContentView.swift
//  Loopover
//
//  Created by Tyler McCormick on 3/2/24.
//

import SwiftUI

extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
let cTeal = Color(UIColor(hex: "#007173"))

struct ContentView: View {
    @ObservedObject var board = Board(5,5)
    var body: some View {
        VStack {
            Spacer()
            LazyVGrid(columns: Array(repeating: GridItem(), count: board.cols), spacing: 10) {
                ForEach(0..<board.rows * board.cols, id: \.self) { index in
                    Text("\(board.board[index / board.cols][index % board.cols])")
                        .frame(width: 50, height: 50)
                        .border(Color.white)
                        .foregroundColor(.white)
                }
            }
            Spacer()
            Button(action: {board.scramble()}) {
                Image(systemName: "arrow.triangle.2.circlepath")
                    .padding()
                    .font(.title)
                    .foregroundColor(.teal)
            }
            .background(Color.white)
            .cornerRadius(10)
        }
        .padding()
        .background(Color(cTeal))
    }
}


#Preview {
    ContentView()
}
