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
let cTeal = Color(UIColor(hex: "#008073"))

struct ContentView: View {
    @ObservedObject var board = Board(5,5)
    
    @State private var offset = CGSize.zero
    @State private var isDragging = false
    
    
    func formatTime(_ time: Int) -> String{
        let minutes = self.board.seconds / 60
        let seconds = self.board.seconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    var body: some View {
        VStack {
            Text(formatTime(self.board.seconds))
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
        .onAppear{
            self.board.startTimer()
        }
        .padding()
        .background(Color(cTeal))
    }
    
}


#Preview {
    ContentView()
}
