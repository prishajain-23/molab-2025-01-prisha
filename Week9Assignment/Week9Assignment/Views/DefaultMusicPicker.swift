//
//  DefaultMusicPicker.swift
//  Week9Assignment
//
//  Created by Prisha Jain on 4/8/25.
//

// accesses the "default" files that are part of the app
// doesn't work right now

import SwiftUI

struct DefaultMusicPicker: View {
    /// Callback that returns the selected audio file's URL
    let onPick: (URL) -> Void

    /// Dismiss action to close the sheet after selection
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            List {
                // Dynamically list all valid audio files in the Music folder
                ForEach(bundledAudioFiles(), id: \.lastPathComponent) { url in
                    Button(url.lastPathComponent) {
                        onPick(url)   // Send selected file back to TrackView
                        dismiss()     // Close the picker sheet
                    }
                }
            }
            .navigationTitle("Music Folder")
        }
    }

    /// Returns an array of URLs pointing to audio files inside the bundled `Music` folder.
    /// Only includes files with supported audio extensions.
    private func bundledAudioFiles() -> [URL] {
        // Get the path to the app's bundled resources
        guard let resourceURL = Bundle.main.resourceURL else { return [] }

        // Look for a subfolder named "Music" inside the bundle
        let musicURL = resourceURL.appendingPathComponent("Music")

        let fileManager = FileManager.default
        let audioExtensions = ["mp3", "wav", "m4a", "aiff"]

        // Attempt to list all contents of the Music folder
        let files = (try? fileManager.contentsOfDirectory(at: musicURL, includingPropertiesForKeys: nil)) ?? []

        // Filter only supported audio file types
        return files.filter { audioExtensions.contains($0.pathExtension.lowercased()) }
    }
}
