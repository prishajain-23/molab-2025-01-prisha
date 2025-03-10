//
//  PianoKey.swift
//  Week6Assignment
//
//  Created by Prisha Jain on 3/8/25.
//

// defines one key on the keyboard

import Foundation

struct PianoKey: Identifiable {
    let id = UUID()
    let note: UInt8
    let isBlack: Bool
}
