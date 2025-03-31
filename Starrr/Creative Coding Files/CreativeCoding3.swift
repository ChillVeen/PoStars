//
//  CreativeCoding3.swift
//  Starrr
//
//  Created by DWA on 18/03/25.
//

import SwiftUI

struct Star: Identifiable {
    let id = UUID()
    var position: CGPoint
    var size: CGFloat
    var speed: CGFloat
    var angle: CGFloat // Add angle to control direction
}

struct CreativeCoding3: View {
    @State private var stars: [Star] = []
    @State private var timer: Timer?

    var body: some View {
        Canvas { context, size in
            // Draw each star
            for star in stars {
                let rect = CGRect(
                    x: star.position.x - star.size / 2,
                    y: star.position.y - star.size / 2,
                    width: star.size,
                    height: star.size
                )
                context.fill(
                    Path(ellipseIn: rect),
                    with: .color(.white)
                )
            }
        }
        .background(Color.black) // Black background for the night sky
        .onAppear {
            // Start the animation loop
            timer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { _ in
                updateStars()
            }
        }
        .onDisappear {
            // Stop the timer when the view disappears
            timer?.invalidate()
        }
    }

    private func updateStars() {
        let screenSize = UIScreen.main.bounds.size
        let center = CGPoint(x: screenSize.width / 2, y: screenSize.height / 2)

        // Add new stars at the center
        if stars.count < 100 { // Limit the number of stars
            let newStar = Star(
                position: center,
                size: CGFloat.random(in: 1...3), // Random size
                speed: CGFloat.random(in: 1...5), // Random speed
                angle: CGFloat.random(in: 0..<2 * .pi) // Random angle (0 to 2π)
            )
            stars.append(newStar)
        }

        // Move stars outward
        var starsToRemove: [UUID] = [] // Track stars to remove
        for index in stars.indices {
            // Move the star based on its angle and speed
            stars[index].position.x += cos(stars[index].angle) * stars[index].speed
            stars[index].position.y += sin(stars[index].angle) * stars[index].speed

            // Mark stars that go off-screen for removal
            if stars[index].position.x < 0 || stars[index].position.x > screenSize.width ||
                stars[index].position.y < 0 || stars[index].position.y > screenSize.height {
                starsToRemove.append(stars[index].id)
            }
        }

        // Remove off-screen stars
        stars.removeAll { star in
            starsToRemove.contains(star.id)
        }
    }
}

#Preview {
    CreativeCoding3()
}
