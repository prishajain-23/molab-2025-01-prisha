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
    let player = AVAudioPlayerNode()
    let pitchControl = AVAudioUnitTimePitch()
    let beatDetector = BeatDetector()

    var currentTrack: String?
    var isPlaying = false
    var playbackRate: Float = 1.0 {
        didSet {
            pitchControl.rate = playbackRate
        }
    }

    init() {
        setupEngine()
    }

    private func setupEngine() {
        engine.attach(player)
        engine.attach(pitchControl)

        engine.connect(player, to: pitchControl, format: nil)
        engine.connect(pitchControl, to: engine.mainMixerNode, format: nil)

        // 🔁 Install tap to send audio to beat detector
        engine.mainMixerNode.installTap(onBus: 0, bufferSize: 1024, format: engine.mainMixerNode.outputFormat(forBus: 0)) { buffer, _ in
            self.beatDetector.tempi.audioReceived(buffer: buffer)
        }

        do {
            try engine.start()
            print("✅ Audio Engine Started")
        } catch
            print("❌ Audio Engine failed: \(error)")
        }
    }

    func loadTrack(named fileName: String) {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: nil) else {
            print("❌ Couldn't find file: \(fileName)")
            return
        }

        do {
            let file = try AVAudioFile(forReading: url)
            player.stop()
            player.scheduleFile(file, at: nil)
            currentTrack = fileName
        } catch {
            print("❌ Failed to load track: \(error)")
        }
    }

    func play() {
        if !player.isPlaying {
            player.play()
            isPlaying = true
        }
    }

    func stop() {
        player.stop()
        isPlaying = false
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
