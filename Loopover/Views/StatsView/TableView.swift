//
//  TableView.swift
//  Loopover
//
//  Created by Tyler McCormick on 8/16/24.
//

import SwiftUI

struct TableView<Content: View>: View {
    
    let data: [Solve]
    let rowContent: (Solve) -> Content
    let headers: [String]
    
    init(data: [Solve], headers: [String], @ViewBuilder rowContent: @escaping (Solve) -> Content) {
        self.data = data
        self.rowContent = rowContent
        self.headers = headers
    }
    
    var body: some View {
        VStack(spacing: 0) {
            
            HStack {
                ForEach(headers, id: \.self) { header in
                    Text(header)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            
            ForEach(data) { item in
                rowContent(item)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .border(Color.gray, width: 2)
            }
        }
    }
}

