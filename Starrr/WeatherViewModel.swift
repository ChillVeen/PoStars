//
//  WeatherViewModel.swift
//  Starr
//
//  Created by Igor Tarantino on 05/03/25.
//

//import Foundation
//import WeatherKit
//import CoreLocation
//
//@MainActor
//class WeatherViewModel: ObservableObject {
//    @Published var temperature: Double?
//    @Published var cloudCover: Double?
//    @Published var precipitation: Double?
//    @Published var humidity: Double?
//    @Published var errorMessage: String?
//
//    private let weatherService = WeatherService.shared
//
//    func fetchWeather(for location: CLLocation) async {
//        do {
//            
//            let weather = try await weatherService.weather(for: location)
//
//            temperature = weather.currentWeather.temperature.value
//            cloudCover = weather.currentWeather.cloudCover * 100 // Convert to percentage
//            precipitation = weather.currentWeather.precipitationIntensity.value
//            humidity = weather.currentWeather.humidity * 100 // Convert to percentage
//
//            print("Temperature: \(temperature ?? 0)°C")
//            print("Cloud Coverage: \(cloudCover ?? 0)%")
//            print("Precipitation: \(precipitation ?? 0) mm/h")
//            print("Humidity: \(humidity ?? 0)%")
//            
//        } catch {
//            
//            errorMessage = "Failed to fetch weather data: \(error.localizedDescription)"
//            print(errorMessage ?? "Unknown error")
//        }
//    }
//}

import SwiftUI
import WeatherKit
import CoreLocation



class WeatherViewModel: ObservableObject {
    @Published var temperature: Double?
    @Published var cloudCover: Double?
    @Published var precipitation: Double?
    @Published var humidity: Double?
    @Published var errorMessage: String?

    @Published var hourlyTemperature: Double?
    @Published var hourlyCondition: String?
    @Published var hourlyPrecipitationChance: Double?
    @Published var hourlyHumidity: Double?
    
    @State private var apiResponse: APIResponse?

    private let weatherService = WeatherService.shared

    func fetchWeather(for location: CLLocation) async {
        do {
            let weather = try await weatherService.weather(for: location)

            // Current weather data
            temperature = weather.currentWeather.temperature.value
            cloudCover = weather.currentWeather.cloudCover * 100
            precipitation = weather.currentWeather.precipitationIntensity.value
            humidity = weather.currentWeather.humidity * 100

            print("Current Weather:")
            print("Temperature: \(temperature ?? 0)°C")
            print("Cloud Coverage: \(cloudCover ?? 0)%")
            print("Precipitation: \(precipitation ?? 0) mm/h")
            print("Humidity: \(humidity ?? 0)%")

            // Fetch hourly weather data for a specific hour (e.g., 3 PM)
            await fetchHourlyWeather(for: location, targetHour: Calendar.current.component(.hour, from: .now))

        } catch {
            errorMessage = "Failed to fetch weather data: \(error.localizedDescription)"
            print(errorMessage ?? "Unknown error")
        }
    }

    func fetchHourlyWeather(for location: CLLocation, targetHour: Int) async {
        do {
            let weather = try await weatherService.weather(for: location)
            let hourlyForecast = weather.hourlyForecast

            // Find the weather data for the target hour
            let calendar = Calendar.current
            let targetDate = calendar.date(bySettingHour: targetHour, minute: 0, second: 0, of: Date())!
            print(Calendar.current.component(.hour, from: .now))
            
            if let hourWeather = hourlyForecast.first(where: { calendar.isDate($0.date, equalTo: targetDate, toGranularity: .hour) }) {
                
                // Update hourly weather properties
                hourlyTemperature = hourWeather.temperature.value
                hourlyCondition = hourWeather.condition.description
                hourlyPrecipitationChance = hourWeather.precipitationChance * 100
                hourlyHumidity = hourWeather.humidity * 100

                print("\nHourly Weather at \(targetHour):00:")
                print("Temperature: \(hourlyTemperature ?? 0)°C")
                print("Condition: \(hourlyCondition ?? "N/A")")
                print("Precipitation Chance: \(hourlyPrecipitationChance ?? 0)%")
                print("Humidity: \(hourlyHumidity ?? 0)%")

            } else {
                errorMessage = "No weather data available for the specified hour."
                print(errorMessage ?? "Unknown error")
            }

        } catch {
            errorMessage = "Failed to fetch hourly weather data: \(error.localizedDescription)"
            print(errorMessage ?? "Unknown error")
        }
    }
}
