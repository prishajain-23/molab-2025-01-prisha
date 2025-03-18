//
//  AmplitudeVisualizer 2.swift
//  Week7Assignment
//
//  Created by Prisha Jain on 3/14/25.
//


//
//  AmplitudeVisualizer.swift
//  Visualizer
//
//  Created by Macbook on 7/30/20.
//  Updated for Swift 5.9+ by ChatGPT on 3/12/25.
//

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
    Ampli
}
