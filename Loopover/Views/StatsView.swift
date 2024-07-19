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
    @StateObject private var viewModel = StatsViewModel()
    
    @Query(sort: \Solve.gameTime, order: .reverse) var allSolves: [Solve]
    
    @State private var numToGet: Int = 3
    @State private var gridSize: Int = 5

    private var filteredSolves: [Solve] {
        return allSolves.compactMap { solve in
            solve.gridSize == gridSize ? solve : nil
        }
    }
    
    private var recentSolves: [Solve] {
//        if filteredSolves.count < numToGet {
        return allSolves
//        } else {
//            return Array(filteredSolves[0..<numToGet])
//        }
    }
    
    private var averageSolveTime: String {
        guard filteredSolves.count > 0 else { return "--:--:--" }
        
        let total = filteredSolves.reduce(0) { result, solve in
            result + solve.timeInHundreths
        }
        
        let average = Double(total) / Double(filteredSolves.count)
        
        return hundrethsToFormattedTime(Int(average))
    }
    
    func hundrethsToFormattedTime(_ hundreths: Int) -> String {
        let minutes = hundreths / 6000
        let seconds = (hundreths % 6000) / 100
        let hundredths = (hundreths % 100)
        
        return String(format: "%02d:%02d.%02d", minutes, seconds, hundredths)
    }
    
    var body: some View {
        if self.allSolves.isEmpty {
            ContentUnavailableView("No solves yet", systemImage: "chart.bar.fill", description: Text("Start solving to view stats"))
                .navigationTitle("Stats")
        } else {
            VStack {
                Picker("Board Size", selection: $gridSize) {
                    Text("3x3").tag(3)
                    Text("4x4").tag(4)
                    Text("5x5").tag(5)
                    Text("6x6").tag(6)
                    Text("7x7").tag(7)
                }
                .pickerStyle(.segmented)
                
                HStack {
                    MiniStatView(text: "Total Solves", number: String(filteredSolves.count))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                    
                    MiniStatView(text: "Average Solve Time", number: averageSolveTime)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                }
                
                Chart {
                    ForEach(Array(self.filteredSolves.enumerated()), id: \.element.id) { offset, solve in
                        LineMark(
                            x: .value("Date", "Game \(offset+1)"),
                            y: .value("Moves", solve[keyPath: viewModel.selectedKeyPath])
                        )
                        .foregroundStyle(by: .value("Grid Size", String(solve.gridSize)))
                        .symbol(by: .value("Grid Size", String(solve.gridSize)))
                    }
                }
                .chartXAxis(.hidden)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                
                Picker("Value", selection: $viewModel.selectedPath) {
                    Text("Moves").tag(0)
                    Text("Time").tag(1)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding([.trailing])
                

            }
            .padding(9)
            .navigationTitle("Stats")
        }
    }
}

#Preview {
    StatsView()
        .modelContext(createModelContext())
}

struct MiniStatView: View {
    
    let text: String
    let number: String
    
    init(text: String, number: String) {
        self.text = text
        self.number = number
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(text)
            Text(number)
                .lineLimit(1)
                .font(.largeTitle)
                .bold()
        }
    }
}
