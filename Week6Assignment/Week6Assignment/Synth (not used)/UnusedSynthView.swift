//
//  SynthView.swift
//  Week6Assignment
//
//  Created by Prisha Jain on 3/8/25.
//

// NOT THE ACTUAL SYNTH!! See SynthView for the one I actually used
// This is a synth layout i tried to make on my own
// PianoKey and KeyboardLayout define the visual components
// KeyView, KeyboardView, and UnusedSynthView put everything together
// This is kind of ugly I want to spend more time on it later on but would rather focus on recording and storing as JSON

import SwiftUI
import AudioKit
import SoundpipeAudioKit

struct UnusedSynthView: View {
    @State private var synthEngine = SynthEngine()

    var body: some View {
        VStack {
            Text("🎹 Synth")
                .font(.largeTitle)
                .padding(.top, 20)

            // Custom Piano Keyboard
            KeyboardView { midiNote in
                let frequency = midiToFrequency(midiNote: midiNote)
                synthEngine.playNote(frequency: frequency)
            } noteOff: { _ in
                synthEngine.stopNote()
            }
            .padding()

            // Stop Sound Button
            Button("Stop") {
                synthEngine.stopNote()
            }
            .frame(width: 100, height: 40)
            .background(Color.red.opacity(0.7))
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding()
        }
        .navigationTitle("Synth")
    }
}

#Preview {
    UnusedSynthView()
}
