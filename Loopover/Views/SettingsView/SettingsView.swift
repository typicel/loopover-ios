//
//  SwiftUIView.swift
//  Loopover
//
//  Created by Noah Tabori on 3/3/24.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    
    @AppStorage("showNumbersOnly") var showNumbersOnly = false
    @AppStorage("doConfettiEffects") var doConfettiEffects = true
    @AppStorage("doHaptics") var doHaptics = true
    
    @State private var showInfoSheet: Bool = false
    @State private var showAboutSheet: Bool = false
    
    @State private var alertTitle: String = ""
    @State private var alertMessage: String = ""
    @State private var afterDeleteAlert: Bool = false
    @State private var deleteConfirmationAlert: Bool = false
    
    @State private var didError: Bool = false

    let dataManager = SolveStorageManager.shared
    
    func deleteSolves() {
        let result = dataManager.deleteAllSolves()
        switch result {
        case .success():
            alertTitle = "Done"
            alertMessage = "All solve data deleted"
            UserDefaults.standard.resetPersonalBests()
            
        case .failure(let error):
            didError = true
            alertMessage = error.localizedDescription
            alertTitle = "Something went wrong..."
        }
        
    }
    
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
                
                Section(header: Text("Solves")) {
                    Button("Delete All Solves") {
                        deleteConfirmationAlert = true
                    }
                    .tint(.red)
                    .alert("Confirmation", isPresented: $deleteConfirmationAlert) {
                        Button("Delete", role: .destructive) {
                            dismiss()
                            self.deleteSolves()
                            self.afterDeleteAlert = true
                        }
                    } message: {
                        Text("Are you sure you want to delete all sovles? This includes personal bests. This cannot be undone.")
                    }
                }
            }
            .listStyle(.insetGrouped)
            .scrollDisabled(true)
            .navigationTitle("Settings")
            .alert(alertTitle, isPresented: $afterDeleteAlert) {
                
            } message: {
                Text(alertMessage)
            }
        }
    }
}

#Preview {
    SettingsView()
}
