//
//  MIDIHelper.swift
//  Week6Assignment
//
//  Created by Prisha Jain on 3/8/25.
//

// converts MIDI notes to frequency

import Foundation
import AudioKit

func midiToFrequency(midiNote: UInt8) -> AUValue {
    return 440.0 * pow(2.0, (AUValue(midiNote) - 69.0) / 12.0)
}
