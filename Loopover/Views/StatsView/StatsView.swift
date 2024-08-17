//
//  StatsView.swift
//  Loopover
//
//  Created by Tyler McCormick on 7/11/24.
//

import SwiftUI
import CoreData
import Charts

struct StatsView: View {
    @Environment(\.modelContext) var modelContext
    @StateObject var viewModel = StatsViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                Picker("Board Size", selection: $viewModel.selectedGridSize) {
                    Text("3x3").tag(3)
                    Text("4x4").tag(4)
                    Text("5x5").tag(5)
                    Text("6x6").tag(6)
                    Text("7x7").tag(7)
                }
                .pickerStyle(.segmented)
                
                Divider()
                
                VStack {
                    HStack {
                        MiniStatView(text: "Total Solves", number: String(viewModel.filteredSolves.count))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                    }
                    HStack {
                        MiniStatView(text: "Best", number: viewModel .bestStat)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                        MiniStatView(text: "Average", number: viewModel.averageStat)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                        MiniStatView(text: "Median", number: viewModel.medianStat)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                    }
                }
                
                Chart {
                    ForEach(Array(viewModel.filteredSolves.enumerated()), id: \.element.id) { offset, solve in
                        LineMark(
                            x: .value("Date", "Game \(offset+1)"),
                            y: .value("Moves", solve[keyPath: viewModel.selectedKeyPath])
                        )
                        .foregroundStyle(by: .value("Grid Size", String(solve.gridSize)))
                        .symbol(by: .value("Grid Size", String(solve.gridSize)))
                    }
                }
                .chartXAxis(.hidden)
                .chartYAxis {
                    if viewModel.shownStat == .moves {
                        AxisMarks(values: .automatic(desiredCount: 3))
                    } else {
                        AxisMarks(values: .automatic(desiredCount: 3)) {
                            AxisValueLabel(format: TimeFormatStyle())
                            AxisGridLine()
                            AxisTick()
                        }
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                
                Picker("Value", selection: $viewModel.shownStat) {
                    Text("Moves").tag(ShownStat.moves)
                    Text("Time").tag(ShownStat.time)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding([.trailing])
            }
            .padding(9)
            .navigationTitle("Stats")
            .alert(
                "Something went wrong",
                isPresented: $viewModel.error.isNotNil(),
                presenting: viewModel.error,
                actions: { _ in },
                message: { error in
                    Text(error.localizedDescription)
                }
            )


            
        }
        
        .onAppear {
            viewModel.getAllSolves()
        }
    }
}

