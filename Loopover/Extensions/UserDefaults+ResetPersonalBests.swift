//
//  UserDefaults+RemovePBs.swift
//  Loopover
//
//  Created by Tyler McCormick on 8/16/24.
//

import Foundation

extension UserDefaults {
    func resetPersonalBests() {
        let pbs = ["PB_3", "PB_4", "PB_5", "PB_6", "PB_7"]
        pbs.forEach { key in
            print("removing \(key)")
            self.removeObject(forKey: key)
        }
    }
}
