//
//  CircularWaveformView.swift
//  Week7Assignment
//
//  Created by Prisha Jain on 3/17/25.
//

// DIDN'T USE

import SwiftUI
import AudioKit
import SoundpipeAudioKit

struct CircularWaveformView: View {
    let audioManager: AudioManager // No need for @ObservedObject
    let index: Int
    let color: Color

    var body: some View {
        GeometryReader { geometry in
            let size = min(geometry.size.width, geometry.size.height) * 0.8
            let fftData = audioManager.fftData[index] // Access live FFT data

            Canvas { context, size in
                let center = CGPoint(x: size.width / 2, y: size.height / 2)
                let radius = size.width / 2

                var path = Path()
                let numPoints = fftData.count

                for (i, amplitude) in fftData.enumerated() {
                    let angle = (Double(i) / Double(numPoints)) * 2 * .pi
                    let scaledAmplitude = CGFloat(amplitude) * 50

                    let x = center.x + (radius + scaledAmplitude) * cos(angle)
                    let y = center.y + (radius + scaledAmplitude) * sin(angle)

                    if i == 0 {
                        path.move(to: CGPoint(x: x, y: y))
                    } else {
                        path.addLine(to: CGPoint(x: x, y: y))
                    }
                }
                path.closeSubpath()

                context.stroke(path, with: .color(color), lineWidth: 3)
            }
            .frame(width: size, height: size)
            .drawingGroup() // Optimized for performance
        }
    }
}



#Preview {
    CircularWaveformView(audioManager: AudioManager(), index: 5, color: Color.blue)
}
