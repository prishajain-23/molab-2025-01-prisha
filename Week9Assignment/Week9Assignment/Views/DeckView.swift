////
////  DeckView.swift
////  Week8Assignment
////
////  Created by Prisha Jain on 3/30/25.
////
//
//import SwiftUI
//
//struct DeckView: View {
//    @State private var audioManager = AudioManager()
//        .foregroundColor(.green)
//    @State private var selectedTrack: String?
//
//    var body: some View {
//        VStack(spacing: 16) {
//            RoundedRectangle(cornerRadius: 12)
//                .fill(.gray.opacity(0.9))
//                .frame(width: 180, height: 160)
//                .overlay(
//                    VStack {
//                        Text("🎛 Deck")
//                            .font(.headline)
//                            .foregroundColor(.white)
//                        if let file = selectedTrack {
//                            Text("🎵 \(file)")
//                                .font(.caption)
//                                .foregroundColor(.white)
//                        }
//                        Text("BPM: \(Int(audioManager.currentBPM))")
//                            .font(.caption)
//                            .foregroundColor(.green)
//                    }
//                )
//
//            HStack {
//                Button("Play") { audioManager.play() }
//                Button("Stop") { audioManager.stop() }
//            }
//            .buttonStyle(.borderedProminent)
//
//            NavigationLink("Select Track") {
//                SelectTrackView(selectedFileName: $selectedTrack)
//            }
//
////            TempoSliderView(rate: $audioManager.playbackRate)
//        }
//        .onChange(of: selectedTrack) { _, newValue in
//            if let file = newValue {
//                audioManager.loadTrack(named: file)
//            }
//        }
//    }
//}
//
//#Preview {
//    DeckView()
//}
