//
//  APIResponse.swift
//  Starrr
//
//  Created by DWA on 27/02/25.
//

import Foundation

struct APIResponse: Codable {
    let data: [[String]]
    let fields: [String]
}
