//
//  AstronomyAPIAuth.swift
//  Starrr
//
//  Created by Praveen Singh on 27/02/25.
//

import Foundation

class APIAuth {
    static let shared = APIAuth()
    
    private let applicationId: String
    private let applicationSecret: String
    
    private init() {
        // Replace these with your actual credentials
        self.applicationId = "643f48aa-b774-428d-b8d4-2da73d45804d"
        self.applicationSecret = "4d8e7d4356f3ccb9d5c5d9fe33f64366fd93b236b3e6f7fe27f199d7822941f69c170106155a78805b5d6fb7ed3f853a33e2355e4ef44a58d75a9928a4af2b8504062ebb2b4f6f6eaa5eabf0d4366efbb34cbee503f3090253a1c813006e1520cb11fa3aca047abd0c0324b0a3906f17"
    }
    
    func getAuthHeader() -> [String: String] {
        let authString = "\(applicationId):\(applicationSecret)"
        guard let authData = authString.data(using: .utf8) else { return [:] }
        let base64Auth = authData.base64EncodedString()
        return ["Authorization": "Basic \(base64Auth)"]
    }
}
