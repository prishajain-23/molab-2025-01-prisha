//
//  KeyboardLayout.swift
//  Week6Assignment
//
//  Created by Prisha Jain on 3/8/25.
//

// defines layout for all the keys (3 octave keyboard)

import Foundation

struct KeyboardLayout {
    static let keys: [PianoKey] = {
        // assigns sharp notes using isBlack
        let pattern: [(step: Int, isBlack: Bool)] = [
            (0, false), (1, true), (2, false), (3, true), (4, false),
            (5, false), (6, true), (7, false), (8, true), (9, false), (10, true), (11, false)
        ]
        
        var keys: [PianoKey] = []
        // assigns number of octaves
        for octave in 3...5 {
            let baseNote = octave * 12
            for (step, isBlack) in pattern {
                keys.append(PianoKey(note: UInt8(baseNote + step), isBlack: isBlack))
            }
        }
        return keys
    }()
}
