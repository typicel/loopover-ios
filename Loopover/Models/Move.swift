//
//  Move.swift
//  Loopover
//
//  Created by Tyler McCormick on 7/19/24.
//

import Foundation

enum Axis: Int, Codable {
    case Row
    case Col
}

public class Move: NSSecureUnarchiveFromDataTransformer, NSCoding {
    static var supportsSecureCoding: Bool = true
    
    var axis: Axis
    var index: Int
    var n: Int
    
    init(axis: Axis, index: Int, n: Int) {
        self.axis = axis
        self.index = index
        self.n = n
    }
    
    required public init?(coder: NSCoder) {
        guard let axisRawValue = coder.decodeObject(forKey: "axis") as? Int,
              let axis = Axis(rawValue: axisRawValue) else { return nil }
        self.axis = axis
        self.index = coder.decodeInteger(forKey: "index")
        self.n = coder.decodeInteger(forKey: "n")
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(axis.rawValue, forKey: "axis")
        coder.encode(index, forKey: "index")
        coder.encode(n, forKey: "n")
    }
}
