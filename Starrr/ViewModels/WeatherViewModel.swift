//  WeatherViewModel.swift
//  Starr
//
//  Created by Igor Tarantino on 05/03/25.
//

import Foundation
import WeatherKit
import CoreLocation

@MainActor
class WeatherViewModel: ObservableObject {
    @Published var temperature: Double?
    @Published var cloudCover: Double?
    @Published var precipitation: Double?
    @Published var humidity: Double?
    @Published var errorMessage: String?

    private let weatherService = WeatherService.shared

    func fetchWeather(for location: CLLocation) async {
        do {
            
            let weather = try await weatherService.weather(for: location)

            temperature = weather.currentWeather.temperature.value
            cloudCover = weather.currentWeather.cloudCover * 100 // Convert to percentage
            precipitation = weather.currentWeather.precipitationIntensity.value
            humidity = weather.currentWeather.humidity * 100 // Convert to percentage

            print("Temperature: \(temperature ?? 0)°C")
            print("Cloud Coverage: \(cloudCover ?? 0)%")
            print("Precipitation: \(precipitation ?? 0) mm/h")
            print("Humidity: \(humidity ?? 0)%")
            
        } catch {
            
            errorMessage = "Failed to fetch weather data: \(error.localizedDescription)"
            print(errorMessage ?? "Unknown error")
        }
    }
}
