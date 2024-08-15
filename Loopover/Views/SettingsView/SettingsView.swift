//
//  SwiftUIView.swift
//  Loopover
//
//  Created by Noah Tabori on 3/3/24.
//

import SwiftUI

struct SettingsView: View {
    
    @AppStorage("showNumbersOnly") var showNumbersOnly = false
    @AppStorage("doConfettiEffects") var doConfettiEffects = true
    @AppStorage("doHaptics") var doHaptics = true
    
    @State private var showInfoSheet: Bool = false
    @State private var showAboutSheet: Bool = false
    
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Appearance")) {
                    HStack {
                        Picker("Square Style", selection: $showNumbersOnly) {
                            Text("Letters").tag(false)
                            Text("Numbers").tag(true)
                        }
                        .pickerStyle(.automatic)
                        .onChange(of: showNumbersOnly) {
                            UserDefaults.standard.setValue(showNumbersOnly, forKey: "showNumbersOnly")
                        }
                    }
                    
                    HStack {
                        Toggle("Confetti", isOn: $doConfettiEffects)
                            .onChange(of: doConfettiEffects) {
                                UserDefaults.standard.setValue(doConfettiEffects, forKey: "doConfettiEffects")
                            }
                    }
                    
                    HStack {
                        Toggle("Haptics", isOn: $doHaptics)
                            .onChange(of: doHaptics) {
                                UserDefaults.standard.setValue(doHaptics, forKey: "doHaptics")
                            }
                    }
                }
                
                Section(header: Text("Info")) {
                    NavigationLink {
                        HowToPlayView()
                    } label: {
                        HStack {
                            Image(systemName: "info.circle")
                            Text("How to Play")
                        }
                        .foregroundColor(.blue)
                    }
                    
                    NavigationLink {
                        AboutView()
                    } label: {
                        HStack {
                            Image(systemName: "questionmark")
                            Text("About")
                        }
                        .foregroundColor(.blue)
                    }
                }
            }
            .listStyle(.insetGrouped)
            .scrollDisabled(true)
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
}
