//
//  AsteroidViewModel.swift
//  NasaApiApp
//
//  Created by Praveen Singh on 30/01/25.
//

import Foundation

class AsteroidViewModel: ObservableObject {
    @Published var asteroids: [Asteroid] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let apiService = NASAAPIService()
    
    var sortedAsteroids: [Asteroid] {
        // Sort by date and then by distance
        return asteroids.sorted { first, second in
            guard let date1 = DateFormatter.asteroidDate.date(from: first.date),
                  let date2 = DateFormatter.asteroidDate.date(from: second.date) else {
                return false
            }
            if date1 == date2 {
                return (first.distanceLD ?? .infinity) < (second.distanceLD ?? .infinity)
            }
            return date1 < date2
        }
    }
    
    func fetchAsteroidData() {
        isLoading = true
        errorMessage = nil
        
        apiService.fetchAsteroidData { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let response):
                    self?.asteroids = response.data.compactMap { Asteroid(from: $0, fields: response.fields) }
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}

// DateFormatter remains the same
extension DateFormatter {
    static let asteroidDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MMM-dd HH:mm"
        return formatter
    }()
}

// End of file. No additional code.
