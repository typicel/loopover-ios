//
//  Box.swift
//  Loopover
//
//  Created by Tyler McCormick on 3/2/24.
//

import SwiftUI

struct Box: View {
    var text: String
    var size: CGFloat
    var color: Color
    
    var body: some View {
        Text(text)
            .font(.title)
            .bold()
            .frame(width: size, height: size)
            .foregroundStyle(Color.black)
            .background(color)
    }
}

#Preview {
    Box(text: "A", size: 75, color: Color(red: 1.0, green: 0.0, blue: 0.0))
}
