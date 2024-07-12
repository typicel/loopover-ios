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
    
    @State private var selectedPath: Int = 0
    let values: [KeyPath<Solve, Int>] = [\.numMoves, \.timeInHundreths]
    
    @State private var solves: [Solve] = [Solve]()
    
    @State private var keyPath: KeyPath<Solve, Int> = \.numMoves
    
    var body: some View {
        VStack {
            Chart {
                ForEach(Array(solves.enumerated()), id: \.element.id) { offset, solve in
                    BarMark(
                        x: .value("Date", "Game \(offset+1)"),
                        y: .value("Moves", solve[keyPath: values[selectedPath]])
                    )
                    .foregroundStyle(by: .value("Grid Size", String(solve.gridSize)))
                    .symbol(by: .value("Grid Size", String(solve.gridSize)))
                }
            }
            .padding()
            
            Picker("Value", selection: $selectedPath) {
                Text("Number of Moves").tag(0)
                Text("Time In Hundreths").tag(1)
            }
            
            List {
                ForEach(solves, id: \.gameTime) { solve in
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
                self.solves = try modelContext.fetch(descriptor)
            } catch {
                print("Unable to retrieve")
                self.solves = []
            }
        }
    }
}

#Preview {
    StatsView()
        .modelContainer(for: Solve.self)
}
