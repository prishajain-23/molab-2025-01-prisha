//
//  SynthView.swift
//  Week6Assignment
//
//  Created by Prisha Jain on 3/8/25.
//

// SIMPLE SYNTH!!!
// this synth allows us to play one note at a time. to create a polysynth, we need to create multiple Oscillator() objects inside of SynthEngine()
// but i don't wanna do all that right now lol
// you can choose which scale you want to play in and see the raw frequency you're playing (created by oscillator)

import SwiftUI
import AudioKit
import SoundpipeAudioKit

struct SynthView: View {
    @State private var synthEngine = SynthEngine()
    @State private var compositionStore = CompositionStore()
    @State private var currentNote: NoteWithOctave? = nil
    @State private var selectedScale: Scale = .pentatonic
    @State private var isRecording = false
    @State private var recordedNotes: [String] = []
    @State private var showAlert = false

    // Adaptive button layout
    let columns: [GridItem] = [
        GridItem(.adaptive(minimum: 60, maximum: 80), spacing: 10)
    ]

    var body: some View {
        VStack {
            // Scale Picker
            Picker("Select Scale", selection: $selectedScale) {
                ForEach(Scale.allCases, id: \.self) { scale in
                    Text(scale.rawValue.capitalized)
                }
            }
            .pickerStyle(.segmented)
            .padding()

            // Display frequency of pressed note
            Text(currentNote != nil ? "Frequency: \(Int(currentNote!.frequency)) Hz" : "Press a Key")
                .font(.title2)
                .padding()

            // Scrollable Keyboard
            ScrollView(.vertical) {
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(2...4, id: \.self) { octave in
                        ForEach(selectedScale.notes(octave: octave), id: \.self) { note in
                            Button(note.rawValue) {
                                synthEngine.playNote(frequency: note.frequency)
                                currentNote = note
                                
                                // Record only if recording is ON
                                if isRecording {
                                    recordedNotes.append(note.rawValue)
                                }
                            }
                            .frame(width: 70, height: 70)
                            .background(Color.blue.opacity(0.7))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                    }
                }
                .padding(.horizontal, 10)
                .padding(.bottom, 20) // Prevent last row from being cut off
            }
            .frame(maxHeight: 300) // Ensures scrolling works

            // Stop Sound Button
            Button("Stop") {
                synthEngine.stopNote()
                currentNote = nil
            }
            .frame(width: 100, height: 40)
            .background(Color.red.opacity(0.7))
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding()

            // Recording Controls
            HStack {
                Button(isRecording ? "Stop Recording" : "Start Recording") {
                    if isRecording {
                        isRecording = false
                    } else {
                        recordedNotes.removeAll()
                        isRecording = true
                    }
                }
                .frame(width: 150, height: 40)
                .background(isRecording ? Color.red.opacity(0.7) : Color.green.opacity(0.7))
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .padding()

            // Display Recorded Notes
            if !recordedNotes.isEmpty {
                VStack {
                    Text("Recorded Notes:")
                        .font(.headline)
                    Text(recordedNotes.joined(separator: ", "))
                        .font(.body)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                }
            }

            // Save Composition Button
            if !recordedNotes.isEmpty {
                Button("Save Composition") {
                    compositionStore.saveComposition(notes: recordedNotes)
                    showAlert = true
                }
                .frame(width: 200, height: 40)
                .background(Color.blue.opacity(0.7))
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding()
            }
        }
        .navigationTitle("Synth")
        .alert("Saved!", isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        }
    }
}


#Preview {
    SynthView()
}
