//
//  AboutView.swift
//  Loopover
//
//  Created by Tyler McCormick on 6/11/24.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        NavigationStack {
            List {
                VStack(alignment: .leading) {
                    HStack(alignment: .top) {
                        Image("SplashScreen")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 64)
                            .cornerRadius(10)
                            .padding(.trailing)
                        VStack {
                            Text("Loopover")
                                .bold()
                            Text("Version 1.0")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Loopover created by [carykh](https://x.com/realcarykh?lang=en)")
                        Text("Developed by [Tyler](https://github.com/typicel) and [Noah](https://github.com/nota5633)")
                    }
                }
                
                Link("Need help?", destination: URL(string: "mailto:support@enzottic.me")!)
                Link("Privacy Policy", destination: URL(string: "https://www.enzottic.me/loopover")!)
                NavigationLink("Licenses") {
                    LicensesView()
                }
            }
            .listStyle(.insetGrouped)
            .scrollDisabled(true)

        }
    }
}

#Preview {
    AboutView()
}
