//
//  ContentView.swift
//  Loopover
//
//  Created by Tyler McCormick on 3/2/24.
//

import ConfettiSwiftUI
import CoreHaptics
import SwiftUI

struct ContentView: View {
    private let letters = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ")
    private let sizes = [3, 4, 5, 6]
    
    @StateObject var board = Board(5, 5)
    
    // Dragging
    @State private var availableSpace: CGFloat = 393.0
    @State private var boxSize: CGFloat = 393.0/5.0
    @State private var isDragging = false
    @State private var startPos: (i: Int, j: Int)? = nil
    @State private var availableSize: CGSize? = nil
    @State private var showPopover = false
    @State private var freezeGestures = false
    
    // Num rows/cols
    @State private var gridSize = 5
    @State private var selectedSize = 2
    
    // Confetti and Haptics
    @State private var confettiCounter = 0
    @State private var engine: CHHapticEngine?
    
    // Pb
    @State private var personalBest: String? = UserDefaults.standard.string(forKey: "5")
    
    func performMove(_ oi: Int, _ oj: Int, _ i: Int, _ j: Int) {
        if (oi, oj) != (i, j) {
            let axis = oi != i ? Axis.Row : Axis.Col
            let index = axis == Axis.Row ? oj : oi
            let n = axis == Axis.Row ? i - oi : j - oj
            
            guard index >= 0 && index < self.board.rows else { return }
            
            board.move(Move(axis: axis, index: index, n: n))
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            startPos = (i, j)
            
            if(board.isSolved() && self.board.hundreths > 0) {
                self.freezeGestures = true
                self.board.stopTimer()
                confettiCounter += 1
                complexSuccess()
                
                if let pb = UserDefaults.standard.string(forKey: "\(gridSize)") {
                    if self.board.hundreths < Int(pb)! {
                        UserDefaults.standard.set(self.board.hundreths, forKey: "\(gridSize)")
                    }
                } else {
                    UserDefaults.standard.set(self.board.hundreths, forKey: "\(gridSize)")
                }
                self.personalBest = UserDefaults.standard.string(forKey: "\(gridSize)")
            }
        }
    }
    
    func detectDrag(_ gesture: DragGesture.Value) {
        if freezeGestures == true { return }
        let location = gesture.location
        let i = Int(location.y / boxSize)
        let j = Int(location.x / boxSize)
        
        if !isDragging {
            isDragging = true
            startPos = (i, j)
        } else {
            if let (oi, oj) = startPos {
                performMove(oi, oj, i, j)
            }
        }
    }
    
    func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        do {
            engine = try CHHapticEngine()
            try engine?.start()
        } catch {}
    }
    
    func complexSuccess() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        var events = [CHHapticEvent]()
        
        for i in stride(from: 0, to: 1, by: 0.2) {
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(i))
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(i))
            let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: i/2)
            events.append(event)
        }

        for i in stride(from: 0, to: 1, by: 0.2) {
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(1 - i))
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(1 - i))
            let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: (1 + i)/2)
            events.append(event)
        }

        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {}
    }
    
    var body: some View {
        VStack {
            Text("Loopover")
                .font(.system(size: 48, weight: .heavy))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
            HStack {
                VStack {
                    Text(self.board.formatTime(self.board.hundreths))
                        .font(.title)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    if let pb = personalBest {
                        Text("Personal Best: \(self.board.formatTime(Int(pb)!))")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.caption)
                    } else {
                        Text("Personal Best: 00:00:00")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.caption)
                    }
                }
                
                Spacer()
                
                Button("\(gridSize)x\(gridSize)") {
                    selectedSize = (selectedSize + 1) % sizes.count
                    gridSize = sizes[selectedSize]
                    
                    self.boxSize = availableSpace / CGFloat(gridSize)
                    self.board.resize(gridSize)
                    self.board.stopTimer()
                    self.board.resetTimer()
                    self.freezeGestures = false
                    
                    self.personalBest = UserDefaults.standard.string(forKey: "\(gridSize)")
                }
                .frame(alignment: .bottom)
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(), count: board.cols), spacing: -1) {
                ForEach(0..<board.rows * board.cols, id: \.self) { index in
                    let el = self.board.board[index / board.cols][index % board.cols]
                    if gridSize <= 5 {
                        Box(text: String(self.letters[el.num]), size: boxSize, color: el.color)
                    }
                    else {
                        Box(text: String(el.num+1), size: boxSize, color: el.color)
                    }
                }
            }
            .gesture(
                DragGesture(minimumDistance: 0.1)
                    .onChanged { gesture in
                        self.detectDrag(gesture)
                    }
                    .onEnded { _ in
                        self.isDragging = false
                        self.startPos = nil
                    }
            )
            .background( // to get the grid width
                GeometryReader { reader in
                    Color.clear.onAppear{
                        self.availableSpace = reader.size.width + 10.0
                        self.boxSize = availableSpace / CGFloat(gridSize)
                        self.board.resize(gridSize)
                    }}
            )
            HStack{
                Button("", systemImage: "arrow.triangle.2.circlepath") {
                    board.scramble()
                    board.startTimer()
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    self.freezeGestures = false
                }.padding()
                
                Spacer()
                
                Button("", systemImage: "info.circle", action: {self.showPopover = true})
                    .popover(isPresented: $showPopover, arrowEdge: .top){
                        GameInfoPopover()
                            .padding()
                            .frame(maxWidth: .infinity)
                    }
                    .padding()
                
            }
            Spacer()

        }
        .padding()
        .frame(maxWidth: .infinity)
        .confettiCannon(counter: $confettiCounter, num: 100, openingAngle: Angle(degrees: 0), closingAngle: Angle(degrees: 360), radius: 200)
        .onAppear(perform: prepareHaptics)

        
        }
}


#Preview {
    ContentView()
}
