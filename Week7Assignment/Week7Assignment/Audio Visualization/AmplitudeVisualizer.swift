//
//  AmplitudeVisualizer.swift
//  Visualizer
//
//  Created by Macbook on 7/30/20.
//  Updated for Swift 5.9+ by ChatGPT on 3/12/25.
//

// DIDN'T USE

import SwiftUI

/// Visualizer for Amplitude Bars
struct AmplitudeVisualizer: View {
    
    @Binding var amplitudes: [Double]
    var colors: [Color]  // 4 extracted colors from image

    var body: some View {
        HStack(spacing: 2.0) { // Adjusted spacing for better visuals
            ForEach(amplitudes.indices, id: \.self) { index in
                VerticalBar(
                    amplitude: $amplitudes[index],
                    color: colors[index % colors.count] // Cycle through colors
                )
            }
        }
        .background(Color.black)
    }
}

#Preview {
    AmplitudeVisualizer(
        amplitudes: .constant(Array(repeating: 1.0, count: 50)),
        colors: [.red, .green, .blue, .yellow]
    )
}
