//
//  StatsView.swift
//  Loopover
//
//  Created by Tyler McCormick on 7/11/24.
//

import SwiftUI
import SwiftData
import Charts

struct StatsView: View {
    @Environment(\.modelContext) var modelContext
    
    @State private var viewModel = StatsViewModel()
    
    var body: some View {
        VStack {
            Chart {
                ForEach(Array(viewModel.solves.enumerated()), id: \.element.id) { offset, solve in
                    BarMark(
                        x: .value("Date", "Game \(offset+1)"),
                        y: .value("Moves", solve[keyPath: viewModel.selectedKeyPath])
                    )
                    .foregroundStyle(by: .value("Grid Size", String(solve.gridSize)))
                    .symbol(by: .value("Grid Size", String(solve.gridSize)))
                }
            }
            .padding()
            
            Picker("Value", selection: $viewModel.selectedPath) {
                Text("Wow! The number of Moves!").tag(0)
                Text("Time In Hundreths").tag(1)
            }
            
            
            List {
                ForEach(viewModel.solves, id: \.gameTime) { solve in
                    Text("\(solve.numMoves)")
                }
            }
            
        }
        .onAppear {
            var descriptor = FetchDescriptor<Solve>(
                sortBy: [
                    .init(\.gameTime, order: .reverse)
                ]
            )
            descriptor.fetchLimit = 5
            
            do {
                viewModel.solves = try modelContext.fetch(descriptor)
            } catch {
                print("Unable to retrieve")
                viewModel.solves = []
            }
        }
        .navigationTitle("Stats")
    }
}

#Preview {
    StatsView()
        .modelContext(createModelContext())
}
