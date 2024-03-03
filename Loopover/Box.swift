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
    
    var body: some View {
        Text(text)
            .font(.title)
            .bold()
            .frame(width: size, height: size)
            .border(Color.white)
            .foregroundColor(.white)
    }
}

#Preview {
    Box(text: "A", size: 75)
}
