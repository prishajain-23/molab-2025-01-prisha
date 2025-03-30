//
//  AudioManager.swift
//  Week8Assignment
//
//  Created by Prisha Jain on 3/20/25.
//

import Foundation
import AVFoundation
import Observation

@Observable
class AudioManager {
    let engine = AVAudioEngine()

    init() {
        setupEngine()
    }

    private func setupEngine() {
        let player = AVAudioPlayerNode()
        engine.attach(player)

        let mixer = engine.mainMixerNode
        engine.connect(player, to: mixer, format: nil)

        do {
            try engine.start()
            print("✅ Audio engine started")
        } catch {
            print("❌ Audio engine failed: \(error)")
        }
    }
}



// WAS GOING TO USE THIS CODE FOR A SYNTH BUT DIDN'T:
//import SwiftUI
//import AudioKit
//import DunneAudioKit
//
//@Observable
//class AudioManager {
//    static let shared = AudioManager()
//
//    let engine = AudioEngine()
//    let synth = Synth()
//
//    private init() {
//        engine.output = synth
//        do {
//            try engine.start()
//        } catch {
//            fatalError("AudioKit failed to start: \(error)")
//        }
//    }
//}
