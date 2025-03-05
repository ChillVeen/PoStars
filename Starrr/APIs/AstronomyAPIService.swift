//
//  AstronomyAPIService.swift
//  Starrr
//
//  Created by Praveen Singh on 27/02/25.
//

import Foundation

struct BodyEventRequest {
    let body: String
    let longitude: String
    let latitude: String
    let elevation: String
    let fromDate: String
    let toDate: String
    let time: String
    let output: String
}

class APIService {
    static let shared = APIService()
    
    private init() {}
    
    func fetchBodyEvents(request: BodyEventRequest, completion: @escaping (Result<Data, Error>) -> Void) {
        var components = URLComponents(string: "https://api.astronomyapi.com/api/v2/bodies/events/\(request.body)")!
        components.queryItems = [
            URLQueryItem(name: "longitude", value: request.longitude),
            URLQueryItem(name: "latitude", value: request.latitude),
            URLQueryItem(name: "elevation", value: request.elevation),
            URLQueryItem(name: "from_date", value: request.fromDate),
            URLQueryItem(name: "to_date", value: request.toDate),
            URLQueryItem(name: "time", value: request.time),
            URLQueryItem(name: "output", value: request.output)
        ]
        
        guard let url = components.url else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = APIAuth.shared.getAuthHeader()
        
        let session = URLSession.shared
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: -1, userInfo: nil)))
                return
            }
            
            completion(.success(data))
        }.resume()
    }
}
