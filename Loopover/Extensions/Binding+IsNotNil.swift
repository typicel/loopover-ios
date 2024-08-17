//
//  Binding+IsNotNil.swift
//  Loopover
//
//  Created by Tyler McCormick on 8/16/24.
//

import SwiftUI

extension Binding {
    func isNotNil<T> () -> Binding<Bool> where Value == T? {
        .init {
            wrappedValue != nil
        } set: { _ in
            wrappedValue = nil
        }
    }
}


