//
//  AudioVisualization.swift
//  SeismometerDrum
//
//  Created by Prisha Jain on 3/2/25.
//

import SwiftUI

struct AudioVisualization: View {
    @State private var rotationAngle: Double = 0  // Rotation state
    @State private var isRotating = false  // Controls rotation animation
    
    @Environment(MotionDetector.self) private var motionDetector
    @Environment(DrumPlayer.self) private var drumPlayer

    var body: some View {
        ZStack {
            // 🎨 Background color mapped to roll (inverse gradient)
            backgroundColor(roll: motionDetector.roll)
                .edgesIgnoringSafeArea(.all)
            
            RotateBezierFlower()
                .frame(width: 200, height: 200)
                .onAppear {
                    startRotation()
                }
                .onChange(of: drumPlayer.isPlaying) { _, isPlaying in
                    if isPlaying {
                        startRotation()
                    } else {
                        stopRotation()
                    }
                }
        }
    }

    // ✅ Background Color (Inverse of Bezier Gradient)
    func backgroundColor(roll: Double) -> Color {
        let normalizedRoll = (roll + .pi) / (2 * .pi) // Normalize roll (-π to π) → (0 to 1)
        let inverseMixFactor = 1 - normalizedRoll // Inverse mapping
        
        return Color(
            red: lerp(start: 0.0 / 255, end: 255.0 / 255, t: inverseMixFactor),
            green: lerp(start: 180.0 / 255, end: 0.0 / 255, t: inverseMixFactor),
            blue: lerp(start: 120.0 / 255, end: 200.0 / 255, t: inverseMixFactor)
        )
    }

    // ✅ Start Rotating Flower when Audio Plays
    func startRotation() {
        isRotating = true
        Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { timer in
            if !isRotating { timer.invalidate() }
            withAnimation(.linear(duration: 0.02)) {
                rotationAngle += 2 // Smooth rotation
            }
        }
    }

    // ✅ Stop Rotation
    func stopRotation() {
        isRotating = false
    }
    
    // ✅ Linear Interpolation (Used for Color Mapping)
    func lerp(start: Double, end: Double, t: Double) -> Double {
        return start + (end - start) * t
    }
}

#Preview {
    AudioVisualization()
        .environment(MotionDetector(updateInterval: 0.01))
        .environment(DrumPlayer())
}
