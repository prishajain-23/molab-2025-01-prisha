//
//  SynthViewModel.swift
//  Week8Assignment
//
//  Created by Prisha Jain on 3/20/25.
//

import SwiftUI
import AudioKit
import DunneAudioKit

@Observable
class SynthViewModel {
    var attackDuration: AUValue = 0.1 {
        didSet { synth.attackDuration = attackDuration }
    }

    var releaseDuration: AUValue = 0.1 {
        didSet { synth.releaseDuration = releaseDuration }
    }

    private let synth = AudioManager.shared.synth

    func playNote(noteNumber: MIDINoteNumber) {
        synth.play(noteNumber: noteNumber, velocity: 100)
    }

    func stopNote(noteNumber: MIDINoteNumber) {
        synth.stop(noteNumber: noteNumber)
    }
}
