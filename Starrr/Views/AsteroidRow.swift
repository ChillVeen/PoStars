//
//  AsteroidRow.swift
//  Starr
//
//  Created by Praveen Singh on 03/02/25.
//


import SwiftUI

struct AsteroidRow: View {
    let asteroid: Asteroid
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Asteroid name
            Text(asteroid.name ?? "Unnamed Asteroid")
                .font(.headline)
                .foregroundColor(.primary)
            
            // Asteroid details in a vertical stack
            VStack(alignment: .leading, spacing: 4) {
                // Date row
                HStack {
                    Image(systemName: "calendar")
                        .foregroundColor(.secondary)
                        .frame(width: 20, alignment: .center)
                    Text(asteroid.date)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                // Lunar distance row
                HStack {
                    Image(systemName: "ruler")
                        .foregroundColor(.secondary)
                        .frame(width: 20, alignment: .center)
                    Text(String(format: "%.2f LD", asteroid.distanceLD ?? 0))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                // Velocity row
                HStack {
                    Image(systemName: "speedometer")
                        .foregroundColor(.secondary)
                        .frame(width: 20, alignment: .center)
                    Text(String(format: "%.2f km/s", asteroid.velocityKmPerSec ?? 0))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
    }
}

