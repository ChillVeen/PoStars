//
//  RequestData.swift
//  Stargazing
//
//  Created by Alessandro Rippa on 11/03/25.
//

import Foundation

// MARK: CAD API
struct AsteroidResponse: Codable {
    let count: Int
    let fields: [String]
    let data: [[String?]]
}

struct Asteroid: Identifiable {
    let id = UUID()
    let designation: String
    let name: String?
    let date: String
    let distanceLD: Double?
    let distanceAU: Double?
    let velocityKmPerSec: Double?
    let diameterKM: Double?
    let hazard: Bool
}

extension Asteroid {
    init?(from rawData: [String?], fields: [String]) {
        // Based on the API response, data comes in this order:
        // 0: designation (des)
        // 3: date (cd)
        // 4: distance (dist)
        // 7: velocity (v_rel)
        // 10: h-magnitude (h)
        
        guard rawData.count >= 11 else { return nil }
        
        self.designation = rawData[0] ?? "Unknown"
        self.name = self.designation  // Using designation as name
        self.date = rawData[3] ?? "Unknown"
        
        // Convert distance from AU to LD (1 AU ≈ 389 LD)
        if let distAUString = rawData[4],
           let distAU = Double(distAUString) {
            self.distanceAU = distAU
            self.distanceLD = distAU * 389.0
        } else {
            self.distanceAU = nil
            self.distanceLD = nil
        }
        
        // Velocity
        self.velocityKmPerSec = rawData[7].flatMap { Double($0) }
        
        // Diameter not available in basic API response
        self.diameterKM = nil
        
        // H-magnitude (higher values generally indicate smaller objects)
        if let hMag = rawData[10].flatMap({ Double($0) }) {
            self.hazard = hMag < 22  // Objects with H < 22 are generally considered potentially hazardous
        } else {
            self.hazard = false
        }
    }
}


//MARK: SB observability API
struct APIResponse: Codable {
    let data: [[String]]
    let fields: [String]
}

