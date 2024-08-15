//
//  Haptics.swift
//  Loopover
//
//  Created by Tyler McCormick on 3/4/24.
//

import Foundation
import CoreHaptics

class GameHaptics {
    var engine: CHHapticEngine?
    
    init() {
        do {
            guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
            self.engine = try CHHapticEngine()
            try engine!.start()
        }
        catch {
            self.engine = nil
            return
        }
    }
    
    func complexSuccess() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        var events = [CHHapticEvent]()
        
        for i in stride(from: 0, to: 1, by: 0.2) {
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(i))
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(i))
            let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: i/2)
            events.append(event)
        }

        for i in stride(from: 0, to: 1, by: 0.2) {
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(1 - i))
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(1 - i))
            let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: (1 + i)/2)
            events.append(event)
        }

        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {}
    }
}
    
