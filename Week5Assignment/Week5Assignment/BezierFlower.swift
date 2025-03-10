//
//  BezierFlower.swift
//  SeismometerDrum
//
//  Created by Prisha Jain on 3/2/25.
//

import SwiftUI

struct BezierFlower: View {
    @Environment(MotionDetector.self) private var motionDetector

    var body: some View {
        GeometryReader { geometry in
            let width = min(geometry.size.width, geometry.size.height)
            let scale: CGFloat = width / 3
            let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
                
            Path { path in
                let topControl = CGPoint(x: center.x, y: center.y - 2 * scale)
                let bottomControl = CGPoint(x: center.x, y: center.y + 2 * scale)
                let leftControl = CGPoint(x: center.x - 2 * scale, y: center.y)
                let rightControl = CGPoint(x: center.x + 2 * scale, y: center.y)

                let leftPoint = CGPoint(x: center.x - scale, y: center.y)
                let rightPoint = CGPoint(x: center.x + scale, y: center.y)
                let topPoint = CGPoint(x: center.x, y: center.y - scale)
                let bottomPoint = CGPoint(x: center.x, y: center.y + scale)

                path.move(to: leftPoint)
                path.addQuadCurve(to: rightPoint, control: topControl)
                path.move(to: topPoint)
                path.addQuadCurve(to: bottomPoint, control: rightControl)
                path.move(to: leftPoint)
                path.addQuadCurve(to: rightPoint, control: bottomControl)
                path.move(to: topPoint)
                path.addQuadCurve(to: bottomPoint, control: leftControl)
            }
            .stroke(
                LinearGradient(
                    gradient: Gradient(colors: gradientColors(for: motionDetector.pitch)),
                    startPoint: .top,
                    endPoint: .bottom
                ),
                lineWidth: 3.0
            )
        }
        .aspectRatio(1, contentMode: .fit)
    }

    // ✅ Maps Pitch to Gradient (Direct Mapping)
    func gradientColors(for pitch: Double) -> [Color] {
        let normalizedPitch = (pitch + .pi / 2) / .pi // Normalize pitch (-π/2 to π/2) → (0 to 1)
        
        let startColor = Color(
            red: lerp(start: 255.0 / 255, end: 0.0 / 255, t: normalizedPitch),
            green: lerp(start: 0.0 / 255, end: 180.0 / 255, t: normalizedPitch),
            blue: lerp(start: 200.0 / 255, end: 120.0 / 255, t: normalizedPitch)
        )
        
        let endColor = Color(
            red: lerp(start: 0.0 / 255, end: 255.0 / 255, t: normalizedPitch),
            green: lerp(start: 180.0 / 255, end: 0.0 / 255, t: normalizedPitch),
            blue: lerp(start: 120.0 / 255, end: 200.0 / 255, t: normalizedPitch)
        )
        
        return [startColor, endColor]
    }

    //  Linear Interpolation for Color Blending
    func lerp(start: Double, end: Double, t: Double) -> Double {
        return start + (end - start) * t
    }
}

#Preview {
    BezierFlower()
        .environment(MotionDetector(updateInterval: 0.01))
        .environment(DrumPlayer())
}
