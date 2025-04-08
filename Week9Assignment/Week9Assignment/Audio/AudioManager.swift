//
//  AudioManager.swift
//  Week9Assignment
//
//  Created by Prisha Jain on 4/1/25.
//

// Singleton class that controls audio playback and EQ filtering.
// It uses AudioKit to build a filter chain with high-pass and low-pass filters, and exposes simple APIs for loading, playing, stopping audio, and adjusting cutoff frequencies.

import Foundation
import AudioKit
import AVFoundation
import Observation

@Observable
@MainActor
final class AudioManager {
    /// Singleton instance
    static let shared = AudioManager()

    /// AudioKit engine that processes and routes audio
    private let engine = AudioEngine()

    /// AudioKit player node that plays loaded audio files
    private let player = AudioPlayer()

    /// First filter: removes low frequencies below a threshold
    private let highPass: HighPassFilter

    /// Second filter: removes high frequencies above a threshold
    private let lowPass: LowPassFilter

    /// UI-controlled cutoff frequency for high-pass filter
    var highPassCutoff: AUValue = 20 {
        didSet {
            highPass.cutoffFrequency = highPassCutoff
        }
    }

    /// UI-controlled cutoff frequency for low-pass filter
    var lowPassCutoff: AUValue = 20_000 {
        didSet {
            lowPass.cutoffFrequency = lowPassCutoff
        }
    }

    /// Name of the currently loaded audio file, shown in UI
    var currentFileName: String = "No file loaded"

    /// Initializes the audio engine and connects nodes in order:
    /// [AudioPlayer] → [HighPassFilter] → [LowPassFilter] → [Output]
    private init() {
        highPass = HighPassFilter(player, cutoffFrequency: 20)
        lowPass = LowPassFilter(highPass, cutoffFrequency: 20_000)
        engine.output = lowPass
    }

    /// Loads an audio file from a given URL and prepares it for playback.
    /// Applies security-scope handling for Files app access.
    func loadAudioFile(url: URL) {
        guard url.startAccessingSecurityScopedResource() else {
            print("❌ Couldn't access file security scope")
            return
        }
        defer { url.stopAccessingSecurityScopedResource() }

        do {
            let file = try AVAudioFile(forReading: url)
            player.stop()
            player.file = file
            player.isLooping = true
            currentFileName = url.lastPathComponent
            print("✅ File loaded: \(currentFileName)")
        } catch {
            print("❌ Error loading audio file: \(error.localizedDescription)")
        }
    }

    /// Starts the audio engine and plays the current file.
    func play() {
        do {
            try engine.start()
            player.play()
        } catch {
            print("❌ Engine failed to start: \(error.localizedDescription)")
        }
    }

    /// Stops playback and shuts down the audio engine.
    func stop() {
        player.stop()
        engine.stop()
    }
}
