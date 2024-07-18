//
//  InfoView.swift
//  Loopover
//
//  Created by Tyler McCormick on 6/10/24.
//

import SwiftUI
import AVKit
import Combine

struct HowToPlayView: View {
    @Environment(\.dismiss) var dismiss
    
    @AppStorage("firstTime") var firstTime = true
    
    @State private var player: AVPlayer = AVPlayer(url: Bundle.main.url(forResource: "square", withExtension: "mp4")!)
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center) {
                VStack(alignment: .leading) {
                    Text("What is Loopover?")
                        .font(.title3)
                        .bold()
                    
                    Text("Loopover is a sliding block puzzle game where the goal is to move each tile to its original position. Swiping a row or column causes the tiles to loop around.")
                    
                    VideoPlayer(player: self.player)
                        .aspectRatio(contentMode: .fit)
                        .onAppear {
                            self.player.play()
                            
                            NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: nil, queue: .main) { _ in
                                self.player.seek(to: .zero)
                                self.player.play()
                            }
                        }
                        .onDisappear {
                            self.player.pause()
                            self.player.seek(to: .zero)
                        }
                        .padding(30)
                    
                    Text("Controls")
                        .font(.title3)
                        .bold()
                    Text("Tap scramble, and swipe rows or columns to move each piece back to its original place")
                    Text("Tap the size button on the top right of the board to change the board size")
                }
                .padding(.bottom, 40)
                
                if self.firstTime {
                    Button("Ok") {
                        self.firstTime = false
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
        }
        .padding()
        
    }
}

#Preview {
    HowToPlayView()
}


