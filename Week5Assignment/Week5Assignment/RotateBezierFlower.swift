//
//  RotateFlower.swift
//  SeismometerDrum
//
//  Created by Prisha Jain on 3/2/25.
//

import SwiftUI

struct RotateBezierFlower: View {
    @State private var rotationAngle: Double = 0  // ✅ Tracks rotation
    @State private var isRotating = false  // ✅ Controls animation state

    @Environment(MotionDetector.self) private var motionDetector
    @Environment(DrumPlayer.self) private var drumPlayer

    var body: some View {
        ZStack {
            ForEach(0..<5, id: \.self) { i in
                BezierFlower()
                    .rotationEffect(Angle(degrees: rotationAngle + Double(i) * 72)) // ✅ Rotates smoothly
            }
        }
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

    // ✅ Start Continuous Rotation
    func startRotation() {
        isRotating = true
        Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { timer in
            if !isRotating { timer.invalidate() }
            withAnimation(.linear(duration: 0.02)) {
                rotationAngle += 2  // ✅ Adjust rotation speed here
            }
        }
    }

    // ✅ Stop Rotation
    func stopRotation() {
        isRotating = false
    }
}

#Preview {
    RotateBezierFlower()
        .environment(MotionDetector(updateInterval: 0.01))
        .environment(DrumPlayer())
}

