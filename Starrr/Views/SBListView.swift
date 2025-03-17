//
//  SBListView.swift
//  Stargazing
//
//  Created by Alessandro Rippa on 11/03/25.
//

//
//  SBosListView.swift
//  Stargazing
//
//  Created by Alessandro Rippa on 13/03/25.
//


import SwiftUI
import CoreLocation
import WeatherKit

// MARK: - Data Models

// MARK: - Main View
struct SBListView: View {
    
    @StateObject private var locationManager = LocationManager()
    @State private var apiResponse: APIResponse?
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    @State private var locationName: String = "Fetching location..."
    @State private var latitude: Double = 23
    @State private var longitude: Double = 4
    
    @State private var date: String = ""
    @State private var place: String = ""
    @State private var location = CLLocation()
    
    // variables for star visualizations
    let starCount = 500
    @State private var starPositions: [CGPoint] = []
    @State private var starSizes: [CGFloat] = []
    @State private var starDepths: [CGFloat] = [] // 0 = far, 1 = close
    @State private var starOpacities: [Double] = []
    
    // variable for weatherkit
    private let weatherService = WeatherService.shared
    @StateObject private var weather = WeatherViewModel()
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                
                if let errorMessage = errorMessage {
                    
                    Text("Unable to fetch coordinates. Please ensure that the localization services are enabled and that the radio signal of your device is strong and try again.")
                        .foregroundStyle(Color.red)
                        .padding()
                    
                    Button(action: {
                        fetchData()
                    }) {
                        Text("Fetch location")
                            .foregroundStyle(Color.white)
                            .padding()
                            .background(Color.blue)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                    }
                }
                
                if isLoading {
                    
                    Spacer()
                    ProgressView("Looking at the sky")
                    
                    
                } else if let apiResponse = apiResponse {
                    
                    TabView {
                        
                        ForEach(apiResponse.data, id: \.self) { object in
                            NavigationLink(destination: DetailView(object: object, fields: apiResponse.fields)) {
                                
                                VStack(alignment: .center) {
                                    
                                    Text(object[1])
                                        .font(.system(size: 30, weight: .bold))
                                        .foregroundStyle(Color.black)
                                    
                                    HStack {
                                        Image(systemName: "location")
                                        Text(locationName)
                                            .font(.subheadline)
                                            .foregroundColor(.blue)
                                    }
                                    
                                    Rectangle()
                                        .frame(height: 200)
                                    
                                    Spacer()
                                    
                                    HStack {
                                        
                                        VStack {
                                            
                                            HStack {
                                                Text("Transit Time")
                                                    .font(.title2)
                                                    .foregroundColor(.black)
                                                
                                                Spacer()
                                                
                                                Text(object[3])
                                                    .font(.title2)
                                                    .foregroundColor(.black)
                                            }
                                            
                                            HStack {
                                                Text("Date")
                                                    .font(.title2)
                                                    .foregroundColor(.black)
                                                
                                                Spacer()
                                                
                                                Text(date)
                                                    .font(.title2)
                                                    .foregroundColor(.black)
                                            }
                                            
                                            HStack {
                                                Text("Temperature")
                                                    .font(.title2)
                                                    .foregroundColor(.black)
                                                
                                                Spacer()
                                                
                                                if let temperature = weather.temperature {
                                                    Text("\(String(format: "%.1f", temperature))°C")
                                                        .font(.title2)
                                                        .foregroundColor(.black)
                                                }
                                            }
                                            
                                            HStack {
                                                Text("Cloud coverage")
                                                    .font(.title2)
                                                    .foregroundColor(.black)
                                                
                                                Spacer()
                                                
                                                if let cloudCover = weather.cloudCover {
                                                    Text("\(String(format: "%.1f", cloudCover))%")
                                                        .font(.title2)
                                                        .foregroundColor(.black)
                                                }
                                            }
                                            
                                            HStack {
                                                Text("Precipitation")
                                                    .font(.title2)
                                                    .foregroundColor(.black)
                                                
                                                Spacer()
                                                
                                                if let precipitation = weather.precipitation {
                                                    Text("\(String(format: "%.1f", precipitation)) mm/h")
                                                        .font(.title2)
                                                        .foregroundColor(.black)
                                                }
                                            }
                                            
                                            HStack {
                                                Text("Humidity")
                                                    .font(.title2)
                                                    .foregroundColor(.black)
                                                
                                                Spacer()
                                                
                                                if let humidity = weather.humidity {
                                                    Text("\(String(format: "%.1f", humidity))%")
                                                        .font(.title2)
                                                        .foregroundColor(.black)
                                                }
                                            }
                                            
                                            HStack {
                                                Rectangle()
                                                    .frame(width: 200)
                                                
                                                Spacer()
                                                
                                                VStack {
                                                    
                                                    Spacer()
                                                    
                                                    HStack {
                                                        
                                                        Button(action: {
                                                            fetchData()
                                                            Task {
                                                                await weather.fetchWeather(for: location)
                                                            }
                                                        }) {
                                                            Image(systemName: "arrow.clockwise")
                                                                .bold()
                                                        }
                                                        .padding()
                                                        .background(Color.blue)
                                                        .foregroundColor(.white)
                                                        .cornerRadius(10)
                                                        .disabled(isLoading || locationManager.coordinates == nil)
                                                        
                                                        Spacer()
                                                    }
                                                    Spacer()
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .tabViewStyle(.page)
                }
                
                Spacer()
            }
            .padding()
            .onAppear {
                // gives a bit of delay to wait for full loading of the locationManager
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    fetchData()
                    Task {
                        await weather.fetchWeather(for: location)
                    }
                }
                // canvas view in swift
                // create an array - grid of 12x8 rectangles
                // procedurally animate the shapes
                // pfjs - javascript
            }
        }
    }
    
    private func fetchLocationName() {
        
        let location = CLLocation(latitude: latitude, longitude: longitude)
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                locationName = "Error: \(error.localizedDescription)"
                return
            }
            
            if let placemark = placemarks?.first {
                let city = placemark.locality ?? "Unknown City"
                let country = placemark.country ?? "Unknown Country"
                locationName = "\(city), \(country)"
                
                
            } else {
                locationName = "No placemark found."
            }
        }
    }
    
    func fetchData() {
        
        guard let coordinates = locationManager.coordinates else {
            errorMessage = "Unable to fetch coordinates."
            return
        }
        
        //MARK: GET DATA
        
        let lon = Double(coordinates.longitude)
        let lat = Double(coordinates.latitude)
        
        longitude = Double(lon)
        latitude = Double(lat)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let currentDate = dateFormatter.string(from: Date())
        
        date = currentDate
        
        let urlString =
        "https://ssd-api.jpl.nasa.gov/sbwobs.api?lat=\(lat)&lon=\(lon)&obs-time=\(currentDate)&maxoutput=5&output-sort=vmag&sb-group=neo"
        
        guard let url = URL(string: urlString) else {
            errorMessage = "Invalid URL"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                isLoading = false
                
                if let error = error {
                    errorMessage = error.localizedDescription
                    return
                }
                
                guard let data = data else {
                    errorMessage = "No data received"
                    return
                }
                
                do {
                    let decodedResponse = try JSONDecoder().decode(APIResponse.self, from: data)
                    apiResponse = decodedResponse
                } catch {
                    errorMessage = "Failed to decode JSON: \(error.localizedDescription)"
                }
            }
        }.resume()
        
        //MARK: LOCATION NAME
        
        let location = CLLocation(latitude: latitude, longitude: longitude)
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                locationName = "Error: \(error.localizedDescription)"
                return
            }
            
            if let placemark = placemarks?.first {
                let city = placemark.locality ?? "Unknown City"
                let country = placemark.country ?? "Unknown Country"
                locationName = "\(city), \(country)"
                
                place = locationName
                
            } else {
                locationName = "No placemark found."
            }
        }
    }
}
