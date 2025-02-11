// working off the Developer Tutorials https://developer.apple.com/tutorials/swiftui

import SwiftUI

struct RotateBezierFlower: View {
    let angle: Angle
    
    var body: some View {
        ZStack { // Stack all rotated flowers on top of each other
            ForEach(0..<5, id: \.self) { i in
                BezierFlower()
                    .rotationEffect(Angle(degrees: Double(i) * angle.degrees))
            }
        }
    }
}

#Preview {
    RotateBezierFlower(angle: Angle(degrees: 72)) // 360° / 5 petals = 72°
}
