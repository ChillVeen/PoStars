//
//  CreativeCoding2.swift
//  Starrr
//
//  Created by Igor Tarantino on 17/03/25.
//

import SwiftUI

import SwiftUI

struct CreativeCoding2: View {
    // Variables to control the lines
    @State private var phase: CGFloat = 0
    let lineThicknesses: [CGFloat] = [3] // Array of thickness values
    let lineSpeed: CGFloat = 0.05
    let lineAmplitude: CGFloat = 50
    let lineSpacing: CGFloat = 10

    var body: some View {
        Canvas { context, size in
            let width = size.width
            let height = size.height

            // Draw S-shaped vertical lines
            for x in stride(from: 0, through: width, by: lineSpacing) {
                // Randomly select a thickness from the array
                let randomThickness = lineThicknesses.randomElement() ?? 2

                // Calculate offsets for the S-shape using sine waves
                let offset1 = sin((x / width) * .pi * 3 + phase) * lineAmplitude
                let offset2 = sin((x / width) * .pi * 3 + phase + .pi) * lineAmplitude

                // Create an S-shaped path
                let path = Path { path in
                    path.move(to: CGPoint(x: x, y: 0)) // Start at the top

                    // Add a cubic Bézier curve for the S-shape
                    let controlPoint1 = CGPoint(x: x + offset1, y: height * 0.3) // First control point
                    let controlPoint2 = CGPoint(x: x + offset2, y: height * 0.9) // Second control point
                    path.addCurve(
                        to: CGPoint(x: x, y: height), // End at the bottom
                        control1: controlPoint1,
                        control2: controlPoint2
                    )
                }

                // Stroke the path with the random thickness
                context.stroke(path, with: .color(.blue), lineWidth: randomThickness)
            }
        }
        .onAppear {
            // Start the animation loop
            Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { _ in
                phase += lineSpeed
            }
        }
    }
}

#Preview {
    CreativeCoding2()
}
