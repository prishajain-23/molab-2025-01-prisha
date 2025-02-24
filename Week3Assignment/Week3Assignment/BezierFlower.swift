import SwiftUI

// hook up sliders to the parameters to lern more about the curves
// maybe check p5 bezier


struct BezierFlower: View {
    var body: some View {
        GeometryReader { geometry in
            // Determine the size of the drawing area
            let width = min(geometry.size.width, geometry.size.height)
            let height = width // Keep it square
            let scale: CGFloat = width / 3 // Scale factor to fit within the view
            let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2) // Center point
                
                Path { path in
                    // Define control points for each petal
                    let topControl = CGPoint(x: center.x, y: center.y - 2 * scale)
                    let bottomControl = CGPoint(x: center.x, y: center.y + 2 * scale)
                    let leftControl = CGPoint(x: center.x - 2 * scale, y: center.y)
                    let rightControl = CGPoint(x: center.x + 2 * scale, y: center.y)
                    
                    // Define start and end points for each petal
                    let leftPoint = CGPoint(x: center.x - scale, y: center.y)
                    let rightPoint = CGPoint(x: center.x + scale, y: center.y)
                    let topPoint = CGPoint(x: center.x, y: center.y - scale)
                    let bottomPoint = CGPoint(x: center.x, y: center.y + scale)
                    
                    // Draw the top petal
                    path.move(to: leftPoint) // Start on the left
                    path.addQuadCurve(to: rightPoint, control: topControl) // Curve upwards
                    
                    // Draw the right petal
                    path.move(to: topPoint) // Start at the top
                    path.addQuadCurve(to: bottomPoint, control: rightControl) // Curve right
                    
                    // Draw the bottom petal
                    path.move(to: leftPoint) // Start on the left again
                    path.addQuadCurve(to: rightPoint, control: bottomControl) // Curve downwards
                    
                    // Draw the left petal
                    path.move(to: topPoint) // Start at the top again
                    path.addQuadCurve(to: bottomPoint, control: leftControl) // Curve left
            }
            .stroke(.linearGradient(
                Gradient(colors: [Self.gradientStart, Self.gradientEnd]),
                startPoint: UnitPoint(x: 0.5, y: 0),
                endPoint: UnitPoint(x: 0.5, y: 0.6)
            ), lineWidth: 3.0)
        }
        .aspectRatio(1, contentMode: .fit)
    }
    static let gradientStart = Color(red: 255.0 / 255, green: 0.0 / 255, blue: 200.0 / 255)
    static let gradientEnd = Color(red: 0.0 / 255, green: 180.0 / 255, blue: 120.0 / 255)
}

#Preview {
    BezierFlower()
}
