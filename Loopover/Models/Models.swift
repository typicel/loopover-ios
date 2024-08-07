//
//  Models.swift
//  Loopover
//
//  Created by Tyler McCormick on 7/11/24.
//

import Foundation
import SwiftUI

enum Axis {
    case Row
    case Col
}

struct Move {
    var axis: Axis
    var index: Int
    var n: Int
}

struct Element {
    var num: Int
    var color: Color
}

