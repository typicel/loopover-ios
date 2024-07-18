//
//  TopInfoBar.swift
//  Loopover
//
//  Created by Tyler McCormick on 7/11/24.
//

import SwiftUI
import SwiftData

struct TopInfoBar: View {
    
    @EnvironmentObject var viewModel: GameViewModel
    
    var body: some View {
        HStack(alignment: .bottom) {
            // PB Timer
            VStack(alignment: .leading) {
                Text(viewModel.board.formatTime(viewModel.hundreths))
                    .font(.title)
                
                if let pb = viewModel.personalBest {
                    Text("Personal Best: \(viewModel.board.formatTime(Int(pb)!))")
                        .font(.subheadline)
                } else {
                    Text("Personal Best: --:--:--")
                        .font(.subheadline)
                }
                
            } // VStack
            
            Spacer()
            
            // Grid Size Button
            Picker("", selection: $viewModel.selectedSizeIdx) {
                ForEach(Array(Constants.sizes.enumerated()), id: \.offset) { offset, size in
                    Text("\(size)x\(size)").tag(offset)
                }
            }
            .pickerStyle(.automatic)
            .onChange(of: viewModel.selectedSizeIdx) {
                viewModel.resizeBoard()
            }
            
        }
    }
}

//#Preview {
//    let modelContext = try! ModelContainer(for: Solve.self).mainContext
//    TopInfoBar()
//        .environmentObject(GameViewModel(modelContext: modelContext))
//}
