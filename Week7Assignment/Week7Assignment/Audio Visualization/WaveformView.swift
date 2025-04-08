//
//  WaveformView.swift
//  Week7Assignment
//
//  Created by Prisha Jain on 3/17/25.
//

import SwiftUI
import AudioKit
import AudioKitEX
import SoundpipeAudioKit
import AudioKitUI

struct WaveformView: View {
    var node: Node // The oscillator input
    var color: Color // The color of the waveform

    var body: some View {
        NodeOutputView(node)
            .background(Color.secondary.opacity(0.2)) // Slight background contrast
            .foregroundColor(color) // Apply extracted color to waveform
            .frame(height: 100)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.horizontal)
    }
}
