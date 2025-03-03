//
//  TrackView.swift
//  SongsAndSamples
//
//  Created by Prisha Jain on 2/24/25.
//

import SwiftUI

struct TrackView: View {
    var trackName: String = "Example trackName"
    var trackImageName: String  = "Example Image Name" // New property for the track image
    @Binding var volume: Float
    @Binding var waveformData: [CGFloat]
    var buttonColor: Color
    @Binding var isPlaying: Bool
  var togglePlayback: () -> Void = { }

    var body: some View {
        VStack {
            // Display the track image
            Image(trackImageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 100, alignment: .center)
//                .border(Color.red) // Debug: highlights the image frame
            
            Text(trackName)
                .foregroundColor(.white)
                .font(.headline)
            
            Button(action: {
                togglePlayback()
            }) {
                Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                    .foregroundColor(.white)
                    .font(.title)
                    .padding()
                    .frame(width: 100)
                    .background(buttonColor)
                    .cornerRadius(8)
            }
            
            WaveformView(waveformData: waveformData, color: buttonColor)
                .frame(height: 40)
            
            Text("Volume")
                .foregroundColor(.white)
                .font(.caption)
            
            Slider(value: $volume, in: 0...1)
                .accentColor(buttonColor)
                .frame(width: 120)
        }
    }
}

struct WaveformView: View {
    var waveformData: [CGFloat]
    var color: Color

    var body: some View {
        HStack(spacing: 2) {
            ForEach(waveformData.indices, id: \.self) { index in
                let level = waveformData[index]
                RoundedRectangle(cornerRadius: 2)
                    .fill(color)
                    .frame(width: 4, height: max(level * 40, 4))
            }
        }
        .animation(.linear(duration: 0.05), value: waveformData)
    }
}


#Preview {
  @Previewable
  @State var waveformData: [CGFloat] = Array(repeating: 0.5, count: 100)
  TrackView(volume: .constant(0.5), waveformData: $waveformData, buttonColor: Color.blue, isPlaying: .constant(false))
}
