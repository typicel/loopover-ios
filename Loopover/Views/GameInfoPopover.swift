//
//  SwiftUIView.swift
//  Loopover
//
//  Created by Noah Tabori on 3/3/24.
//

import SwiftUI

struct GameInfoPopover: View {
    
    @AppStorage("showNumbersOnly") var showNumbersOnly = false
    @AppStorage("doConfettiEffects") var doConfettiEffects = true
    @AppStorage("doHaptics") var doHaptics = true
    
    @State private var showInfoSheet: Bool = false
    @State private var showAboutSheet: Bool = false

    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            Text("Settings")
                .font(.system(size: 24))
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .padding()

            List {
                HStack {
                    Text("Square Style")
                    Picker("", selection: $showNumbersOnly) {
                        Text("Letters").tag(false)
                        Text("Numbers").tag(true)
                    }
                    .pickerStyle(.segmented)
                    .padding()
                    .onChange(of: showNumbersOnly) {
                        UserDefaults.standard.setValue(showNumbersOnly, forKey: "showNumbersOnly")
                    }
                }
                
                HStack {
                    Toggle("Confetti", isOn: $doConfettiEffects)
                    .padding()
                    .onChange(of: doConfettiEffects) {
                        UserDefaults.standard.setValue(doConfettiEffects, forKey: "doConfettiEffects")
                    }
                }
                
                HStack {
                    Toggle("Haptics", isOn: $doHaptics)
                    .padding()
                    .onChange(of: doHaptics) {
                        UserDefaults.standard.setValue(doHaptics, forKey: "doHaptics")
                    }
                }
            }
            .listStyle(.plain)
            .scrollDisabled(true)
            

            Spacer()
            
            Button {
                showInfoSheet = true
            } label: {
                Label("How to Play", systemImage: "info.circle")
            }
            .padding()
            
            Button {
                showAboutSheet = true
            } label: {
                Label("About", systemImage: "questionmark")
            }
            .padding()

        }
        .sheet(isPresented: $showInfoSheet) {
            HowToPlayView()
        }
        .sheet(isPresented: $showAboutSheet) {
            AboutView()
        }
    }
}

#Preview {
    GameInfoPopover()
        .environmentObject(GameSettings())
}
