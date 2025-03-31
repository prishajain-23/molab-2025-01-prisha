//
//  SelectTrackView.swift
//  Week8Assignment
//
//  Created by Prisha Jain on 3/30/25.
//

import SwiftUI

struct SelectTrackView: View {
    @Binding var selectedFileName: String?
    let availableTracks = [
        "Track1.mp3",
        "Track2.wav",
        "Track3.m4a"
    ]

    var body: some View {
        List(availableTracks, id: \.self) { track in
            Button(track) {
                selectedFileName = track
            }
        }
        .navigationTitle("Select a Track")
    }
}

#Preview {
    NavigationStack {
        SelectTrackView(selectedFileName: .constant(nil))
    }
}
