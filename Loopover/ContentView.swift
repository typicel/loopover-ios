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
let cTeal = Color(UIColor(hex: "#002925"))

struct ContentView: View {
    @ObservedObject var board = Board(5,5)
    
    @State private var offset = CGSize.zero
    @State private var isDragging = false
    
    
    func formatTime(_ time: Int) -> String{
        let minutes = self.board.hundreths / 6000
        let seconds = (self.board.hundreths / 100) % 60
        let hundreths = self.board.hundreths % 100
        return String(format: "%02d:%02d:%02d", minutes, seconds, hundreths)
    }
    
    var body: some View {
        VStack {
            Spacer()
            Text(formatTime(self.board.hundreths))
            LazyVGrid(columns: Array(repeating: GridItem(), count: board.cols), spacing: 0) {
                        ForEach(0..<board.rows * board.cols, id: \.self) { index in
                            Text("\(board.board[index / board.cols][index % board.cols])")
                                .font(.title)
                                .bold()
                                .frame(width: 75, height: 75)
                                .border(Color.white)
                                .foregroundColor(.white)
                        }
                    }
            Spacer()
            Button(action: {board.scramble(); board.startTimer()}) {
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
        .frame(maxWidth: .infinity)
        .background(Color(cTeal))
    }
    
}


#Preview {
    ContentView()
}
