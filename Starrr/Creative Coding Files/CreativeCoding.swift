//
//  CreativeCoding.swift
//  Starrr
//
//  Created by DWA on 11/03/25.
//

import SwiftUI

struct Particle {
    var position: CGPoint
    var velocity: CGVector
    var angle: Double
    var lenght: CGFloat
}

struct CreativeCoding: View {
    @State private var particles: [Particle] = []
    
//    private var particleCount = 150
//    private let connectionDistance: CGFloat = 105
//    private let timer = Timer.publish(every: 1/60, on: .main, in: .common).autoconnect()
    
    var creativeCoding: ContentView3
    
    var body: some View {
        
        GeometryReader { geo in
            
            Canvas { context, size in
                
                for i in 0..<particles.count {
                    for j in (i + 1)..<particles.count {
                        let dx = particles[i].position.x - particles[j].position.x
                        let dy = particles[i].position.y - particles[j].position.y
                        let distance = sqrt(dx * dx + dy * dy)
                        
                        if distance < creativeCoding.connectionDistance {
                            let opacity = 1.0 - (distance / creativeCoding.connectionDistance)
                            var connectionPath = Path()
                            connectionPath.move(to: particles[i].position)
                            connectionPath.addLine(to: particles[j].position)
                            context.stroke(connectionPath,
                                           with: .color(Color.white.opacity(opacity)),
                                           lineWidth: 0.8)
                        }
                    }
                }
                
                for particle in particles {
                    var particlePath = Path()
                    let halfLenght = particle.lenght / 10
                    let dx = cos(particle.angle) * halfLenght
                    let dy = sin(particle.angle) * halfLenght
                    let startPoint = CGPoint(x: particle.position.x - dx, y: particle.position.y - dy)
                    let endPoint = CGPoint(x: particle.position.x + dx, y: particle.position.y + dy)
                    
                    particlePath.move(to: startPoint)
                    particlePath.addLine(to: endPoint)
                    
                    context.stroke(particlePath, with: .color(.white), lineWidth: 5)
                }
            }
            .background(Color.black)
            .onAppear {
                
                particles = (0..<creativeCoding.particleCount).map { _ in
                    Particle(
                        position: CGPoint(x: CGFloat.random(in: 0...geo.size.width),
                                          y: CGFloat.random(in: 0...geo.size.height)),
                        velocity: CGVector(dx: CGFloat.random(in: -1.5...1.5),
                                           dy: CGFloat.random(in: -1.5...1.5)),
                        angle: Double.random(in: 0...(2 * Double.pi)),
                        lenght: CGFloat.random(in: 10...30)
                    )
                }
            }
            .onReceive(creativeCoding.timer) { _ in
                for index in particles.indices {
                    particles[index].position.x += particles[index].velocity.dx
                    particles[index].position.y += particles[index].velocity.dy
                    
                    if particles[index].position.x < 0 {
                        particles[index].position.x += geo.size.width
                    } else if particles[index].position.x > geo.size.width {
                        particles[index].position.x -= geo.size.width
                    }
                    
                    if particles[index].position.y < 0 {
                        particles[index].position.y += geo.size.height
                    } else if particles[index].position.y > geo.size.height {
                        particles[index].position.y -= geo.size.height
                    }
                    
                    particles[index].angle += 0.02
                }
            }
            .ignoresSafeArea()
        }
    }
}

#Preview {
    CreativeCoding(creativeCoding: ContentView3())
}
