//
//  VerticalBar.swift
//  Visualizer
//
//  Created by Macbook on 7/30/20.
//  Updated for Swift 5.9+ by ChatGPT on 3/12/25.
//

// DIDN'T USE

import SwiftUI

/// Single bar of Amplitude Visualizer
struct VerticalBar: View {
    
    @Binding var amplitude: Double
    var color: Color  // Assigned dynamically from extracted colors

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                
                // Colored rectangle based on extracted color
                Rectangle()
                    .fill(color)
                
                // Dynamic black mask padded from bottom in relation to the amplitude
                Rectangle()
                    .fill(Color.black)
                    .mask(Rectangle().padding(.bottom, geometry.size.height * CGFloat(self.amplitude)))
                    .animation(.easeOut(duration: 0.15), value: amplitude)

                // White floating effect bar for smooth amplitude change
                Rectangle()
                    .fill(Color.white)
                    .frame(height: geometry.size.height * 0.005)
                    .offset(y: -geometry.size.height * CGFloat(self.amplitude) - geometry.size.height * 0.02)
                    .animation(.easeOut(duration: 0.6), value: amplitude)
                
            }
            .padding(geometry.size.width * 0.1)
            .border(Color.black, width: geometry.size.width * 0.1)
        }
    }
}

//#Preview {
//    VerticalBar(
//        amplitude: .constant(0.8), color: .red)
//    .fixed(width: 40, height: 500)
//    )
//}
