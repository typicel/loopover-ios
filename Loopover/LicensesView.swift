//
//  LicensesView.swift
//  Loopover
//
//  Created by Tyler McCormick on 6/11/24.
//

import SwiftUI

struct LicensesView: View {
    var body: some View {
        List {
            Link("ConfettiSwiftUI", destination: URL(string: "https://github.com/simibac/ConfettiSwiftUI/blob/master/LICENSE")!)
        }
    }
}

#Preview {
    LicensesView()
}
