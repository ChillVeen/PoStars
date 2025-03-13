//
//  NASAAPIService.swift
//  NasaApiApp
//
//  Created by Praveen Singh on 30/01/25.
//

import Foundation

class NASAAPIService {
    private let baseURL = "https://ssd-api.jpl.nasa.gov/cad.api"
    
    func fetchAsteroidData(completion: @escaping (Result<AsteroidResponse, Error>) -> Void) {
        guard var urlComponents = URLComponents(string: baseURL) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 400)))
            return
        }
        
        // Get current date and date 7 days from now
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let currentDate = Date()
        let nextWeek = Calendar.current.date(byAdding: .day, value: 7, to: currentDate)!
        
        // Update query parameters to fetch only next 7 days data
        urlComponents.queryItems = [
            URLQueryItem(name: "dist-max", value: "0.05"),
            URLQueryItem(name: "date-min", value: dateFormatter.string(from: currentDate)),
            URLQueryItem(name: "date-max", value: dateFormatter.string(from: nextWeek)),
            URLQueryItem(name: "sort", value: "date"),
            URLQueryItem(name: "body", value: "Earth")
        ]
        
        guard let url = urlComponents.url else {
            completion(.failure(NSError(domain: "Invalid URL", code: 400)))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No Data", code: 404)))
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(AsteroidResponse.self, from: data)
                completion(.success(decodedResponse))
            } catch {
                print("Decoding Error: \(error)")
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}

