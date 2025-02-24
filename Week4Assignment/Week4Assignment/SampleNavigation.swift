//
//  SampleNavigation.swift
//  SongsAndSamples
//
//  Created by Prisha Jain on 2/23/25.
//

import SwiftUI

// Updated data model with image names for each track.
struct Sample: Identifiable {
    let id = UUID()
    let track1Title: String
    let track1FileName: String
    let track1ImageName: String
    let track2Title: String
    let track2FileName: String
    let track2ImageName: String
}

struct SampleNavigation: View {
    let samples = [
        Sample(
            track1Title: "Man of the Year - ScHoolboy Q",
            track1FileName: "manoftheyear",
            track1ImageName: "manoftheyearImage",
            track2Title: "Cherry - Chromatics",
            track2FileName: "cherry",
            track2ImageName: "cherryImage"
        ),
        Sample(
            track1Title: "B*tch Don't Kill My Vibe - Kendrick Lamar",
            track1FileName: "bitchdontkillmyvibe",
            track1ImageName: "bitchdontkillmyvibeImage",
            track2Title: "Tiden Flyver - Boom Clap Bachelors",
            track2FileName: "tidenflyver",
            track2ImageName: "tidenflyverImage"
        ),
        Sample(
            track1Title: "Broken Clocks - SZA",
            track1FileName: "brokenclocks",
            track1ImageName: "brokenclocksImage",
            track2Title: "West - River Tiber",
            track2FileName: "west",
            track2ImageName: "westImage"
        )
    ]
    
    var body: some View {
        NavigationView {
            List(samples) { sample in
                NavigationLink(
                    destination: SongSampleView(
                        track1Title: sample.track1Title,
                        track1FileName: sample.track1FileName,
                        track1ImageName: sample.track1ImageName,
                        track2Title: sample.track2Title,
                        track2FileName: sample.track2FileName,
                        track2ImageName: sample.track2ImageName
                    )
                ) {
                    // Use .primary so the text adapts to dark/light mode.
                    Text("\(sample.track1Title) & \(sample.track2Title)")
                        .foregroundColor(.primary)
                }
                // Use system background to adapt to system settings.
                .listRowBackground(Color(UIColor.systemBackground))
            }
            .navigationTitle("Awesome Songs and Their Samples")
        }
    }
}

#Preview {
    SampleNavigation()
}
