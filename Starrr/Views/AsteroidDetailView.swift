//
//  AsteroidDetailView.swift
//  Starr
//
//  Created by Praveen Singh on 03/02/25.
//

import SwiftUI

struct AsteroidDetailView: View {
    let asteroid: Asteroid
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    
                    // Display A1 or A2 based on hazard status with reduced size
                    Image(asteroid.hazard ? "A2" : "A1")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity)
                        .frame(height: 200) // Reduced height
                        .cornerRadius(12)
                        .padding()
                    
                    // Hazard status indicator centered
                    Text(asteroid.hazard ? "Potentially Hazardous" : "Not Hazardous")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(asteroid.hazard ? .red : .green)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding()
                    
                    
                    // Display asteroid details aligned to the left
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Name:")
                                .font(.headline)
                                .fontWeight(.bold)
                            Text(asteroid.designation)
                                .font(.headline)
                        }
                        
                        HStack {
                            Text("Closest Approach Date:")
                                .font(.subheadline)
                                .fontWeight(.bold)
                            Text(asteroid.date)
                                .font(.subheadline)
                        }
                        
                        if let ld = asteroid.distanceLD {
                            HStack {
                                Text("Minimum Distance:")
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                Text(String(format: "%.2f Lunar Distances", ld))
                                    .font(.subheadline)
                            }
                        }
                        
                        if let velocity = asteroid.velocityKmPerSec {
                            HStack {
                                Text("Relative Velocity:")
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                Text(String(format: "%.2f km/s", velocity))
                                    .font(.subheadline)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    
                    Spacer()
                }
            }
            .navigationTitle("Asteroid Details")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct AsteroidDetailView_Previews: PreviewProvider {
    static var previews: some View {
        AsteroidDetailView(asteroid: Asteroid(
            designation: "2025 AB",
            name: "Example Asteroid",
            date: "2025-Feb-03 12:00",
            distanceLD: 2.5,
            distanceAU: 0.0064,
            velocityKmPerSec: 5.2,
            diameterKM: nil,
            hazard: false
        ))
    }
}
