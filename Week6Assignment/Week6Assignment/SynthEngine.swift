//
//  SynthEngine.swift
//  Week6Assignment
//
//  Created by Prisha Jain on 3/8/25.
//

// Uses AudioKit's Oscillator
// Supports parameter changes (frequency, waveform, ASDR envelope)
// Can start and stop notes when the user plays the keyboard

import Foundation
import AudioKit
import SoundpipeAudioKit
import AVFoundation

@Observable
class SynthEngine {
    let engine = AudioEngine()
    let oscillator = Oscillator()

    init() {
        engine.output = oscillator
        try? engine.start()
    }

    func playNote(frequency: AUValue) {
        oscillator.frequency = frequency
        oscillator.amplitude = 0.5
        oscillator.start()
    }

    func stopNote() {
        oscillator.stop()
    }
}
