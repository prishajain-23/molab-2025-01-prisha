//
//  SelectTrackView.swift
//  Week8Assignment
//
//  Created by Prisha Jain on 3/30/25.
//

import SwiftUI

/// Main interface for the DJ app. Allows users to:
/// - Load audio files from Files or bundled Music folder
/// - Adjust EQ settings with sliders
/// - Play/Stop the track
/// - Save/load EQ settings to/from Firestore under a selected username
struct TrackView: View {
    /// Shared audio manager that controls playback and filtering
    @Bindable var audioManager = AudioManager.shared

    /// UI state: show system file picker
    @State private var showFilePicker = false
    /// UI state: show bundled music file picker
    @State private var showMusicPicker = false
    /// UI state: show user selector interface
    @State private var showUserSelector = false

    /// Shared user session, manages current username
    @State private var session = UserSessionManager.shared
    /// Shared Firebase Firestore interface
    @State private var storage = FirebaseAudioStorage()

    var body: some View {
        VStack(spacing: 20) {
            // Show current username
            if let username = session.currentUsername {
                Text("User: \(username)").font(.caption)
            }

            // Title
            Text("DJ Filter Control")
                .font(.title)
                .bold()

            // Currently loaded audio file
            Text("Loaded File: \(audioManager.currentFileName)")
                .font(.headline)

            // High-pass and low-pass filter sliders
            VStack(spacing: 10) {
                Text("High-Pass: \(Int(audioManager.highPassCutoff)) Hz")
                Slider(value: $audioManager.highPassCutoff, in: 20...20000, step: 100)

                Text("Low-Pass: \(Int(audioManager.lowPassCutoff)) Hz")
                Slider(value: $audioManager.lowPassCutoff, in: 20...20000, step: 100)
            }

            // Playback controls
            HStack(spacing: 20) {
                Button("Play") {
                    audioManager.play()
                }
                Button("Stop") {
                    audioManager.stop()
                }
            }

            // Save current EQ settings to Firestore
            Button("Save EQ Settings") {
                guard let username = session.currentUsername else { return }
                let settings = EQSettings(
                    fileName: audioManager.currentFileName,
                    lowPass: audioManager.lowPassCutoff,
                    highPass: audioManager.highPassCutoff
                )
                Task {
                    await storage.saveEQSettings(username: username, settings: settings)
                }
            }

            // Choose audio file source (Files or Music folder)
            Menu("Load Audio File") {
                Button("From Files") {
                    showFilePicker = true
                }
                Button("From Music Folder") {
                    showMusicPicker = true
                }
            }

            // Switch username
            Button("Switch User") {
                showUserSelector = true
            }
        }
        .padding()

        // System file picker
        .sheet(isPresented: $showFilePicker) {
            AudioFilePicker { url in
                handleAudioFile(url: url)
            }
        }

        // Bundled music folder picker
        .sheet(isPresented: $showMusicPicker) {
            DefaultMusicPicker { url in
                handleAudioFile(url: url)
            }
        }

        // User selection view
        .sheet(isPresented: $showUserSelector) {
            UserSelectView()
        }

        // Prompt to pick a user if none is selected yet
        .onAppear {
            if session.currentUsername == nil {
                showUserSelector = true
            }
        }
    }

    /// Loads the selected audio file into the audio engine,
    /// and fetches any previously saved EQ settings from Firestore.
    private func handleAudioFile(url: URL) {
        audioManager.loadAudioFile(url: url)

        if let username = session.currentUsername {
            Task {
                if let eq = await storage.loadEQSettings(username: username, fileName: url.lastPathComponent) {
                    audioManager.lowPassCutoff = eq.lowPass
                    audioManager.highPassCutoff = eq.highPass
                }
            }
        }
    }
}

#Preview {
    TrackView()
}
