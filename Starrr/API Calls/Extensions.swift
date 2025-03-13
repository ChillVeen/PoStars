//
//  Extensions.swift
//  NasaApiApp
//
//  Created by Praveen Singh on 31/01/25.
//

extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
