//
//  AudioManager.swift
//  Week7Assignment
//  Created by Prisha Jain on 3/12/25

import AudioKit
import AudioKitEX
import SoundpipeAudioKit
import Foundation
import Observation

@Observable
class AudioManager {
    private let oscillators: [Oscillator] = [Oscillator(), Oscillator(), Oscillator()]
    private let panners: [Panner] // panners for stereo positioning
    private let mixer = Mixer()
    private let engine = AudioEngine()
    
    var fftData: [[Float]] = Array(repeating: Array(repeating: 0, count: 256), count: 3)
    
    private var fftTaps: [FFTTap] = []

    init() {
        // Wrap each oscillator with a stereo panner
        panners = oscillators.map { Panner($0) }
        
        // Add panners to the mixer
        panners.forEach { mixer.addInput($0) }
        
        // Set mixer as the engine output
        engine.output = mixer
        
        // Attach FFT taps
        for i in 0..<oscillators.count {
            let tap = FFTTap(oscillators[i]) { fft in
                DispatchQueue.main.async {
                    self.fftData[i] = fft // Store FFT data
                }
            }
            fftTaps.append(tap)
        }
    }

    func startAudioEngine() {
        do {
            try engine.start()
            print("🎛️ Audio Engine Started")
        } catch {
            print("❌ Error starting AudioKit: \(error.localizedDescription)")
        }
    }

    func startOscillators() {
        oscillators.forEach { $0.start() }
        print("▶️ Oscillators Started")
    }

    func stopOscillators() {
        oscillators.forEach { $0.stop() }
        print("⏸ Oscillators Stopped")
    }

    func setFrequency(for index: Int, frequency: Float) {
        if oscillators.indices.contains(index) {
            oscillators[index].frequency = frequency
            print("🎵 Oscillator \(index) Frequency: \(frequency) Hz")
        }
    }

    func setAmplitude(for index: Int, amplitude: Float) {
        if oscillators.indices.contains(index) {
            oscillators[index].amplitude = amplitude
            print("🔊 Oscillator \(index) Amplitude: \(amplitude)")
        }
    }
    
    // Sets the stereo pan (-1 = Left, 0 = Center, 1 = Right) for all oscillators
    func setPan(_ panValue: Float) {
        panners.forEach { $0.pan = panValue }
        print("🔊 Updated Stereo Pan: \(panValue)")
    }
    
    // Returns a specific oscillator node for visualization
    func getOscillatorNode(for index: Int) -> Node {
        return oscillators[index]
    }
}
