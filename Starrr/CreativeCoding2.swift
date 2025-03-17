//
//  CreativeCoding2.swift
//  Starrr
//
//  Created by Igor Tarantino on 17/03/25.
//

import SwiftUI

import SwiftUI

struct CurvedWaveLinesView: View {
    // Variables to control the lines
    @State private var phase: CGFloat = 0
    let lineThicknesses: [CGFloat] = [1, 2, 3, 4, 5] // Array of thickness values
    let lineSpeed: CGFloat = 0.05
    let lineAmplitude: CGFloat = 20
    let lineSpacing: CGFloat = 10

    var body: some View {
        Canvas { context, size in
            let width = size.width
            let height = size.height

            // Draw curved vertical lines
            for x in stride(from: 0, through: width, by: lineSpacing) {
                // Randomly select a thickness from the array
                let randomThickness = lineThicknesses.randomElement() ?? 2

                // Calculate the offset for the curve using a sine wave
                let offset = sin((x / width) * .pi * 2 + phase) * lineAmplitude

                // Create a curved path
                let path = Path { path in
                    path.move(to: CGPoint(x: x, y: 0)) // Start at the top

                    // Add a quadratic Bézier curve
                    let controlPoint = CGPoint(x: x + offset, y: height / 2) // Control point for the curve
                    path.addQuadCurve(to: CGPoint(x: x, y: height), control: controlPoint)
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
    CurvedWaveLinesView()
}
