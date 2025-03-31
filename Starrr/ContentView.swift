//
//  ContentView.swift
//  Starr
//
//  Created by DWA on 26/02/25.
//

import SwiftUI
import CoreLocation
import WeatherKit

// MARK: - Data Models

// MARK: - Main View
struct ContentView: View {
    
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
    
    // variable for opacity of the fetching data screen
    @State private var opacityValue: Double = 1
    
    // variables for creative coding
    var particleCount = 150
    let connectionDistance: CGFloat = 105
    let timer = Timer.publish(every: 1/60, on: .main, in: .common).autoconnect()
    
    var body: some View {
        
        NavigationView {
            
            ZStack {
                
                Color.black
                    .ignoresSafeArea()
                
                CreativeCoding3()
                    .ignoresSafeArea()
                    .opacity(opacityValue)
                    .background(Color.black)
                    .animation(.easeInOut(duration: 2), value: opacityValue)
                
                VStack {
                    
                    if let errorMessage = errorMessage {
                        
                        Text("Unable to fetch coordinates. Please ensure that the localization services are enabled and that the radio signal of your device is strong and try again.")
                            .foregroundStyle(Color.red)
                            .padding()
                            .font(.custom("MontserratAlternates-Bold", size: 15))
                        
                        Button(action: {
                            fetchData()
                        }) {
                            Text("Fetch location")
                                .foregroundStyle(Color.white)
                                .padding()
                                .background(Color.blue)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .font(.custom("MontserratAlternates-Bold", size: 15))
                        }
                    }
                    
                    if isLoading {
                        
                        Spacer()
                        ProgressView("Looking at the sky")
                            .tint(Color.white)
                            .scaleEffect(1.2)
                            .foregroundStyle(Color.white)
                            .font(.custom("MontserratAlternates-Bold", size: 20))
                            .offset(y: 25)
                        
                    } else if let apiResponse = apiResponse {
                        
                        TabView {
                            
                            ForEach(apiResponse.data, id: \.self) { object in
                                NavigationLink(destination: DetailView(object: object, fields: apiResponse.fields)) {
                                    
                                    VStack(alignment: .center) {
                                        
                                        Text(object[1])
                                            .foregroundStyle(Color.white)
                                            .font(.custom("MontserratAlternates-Bold", size: 25))
                                        
//                                        HStack {
//                                            Image(systemName: "location")
//                                            Text(locationName)
//                                                .foregroundColor(.white)
//                                                .font(.custom("MontserratAlternates-Bold", size: 15))
//                                        }
                                        
                                        Image("world")
                                            .resizable()
                                            .scaledToFill()
                                            .clipShape(Rectangle())
                                            .frame(height:200)
                                        /*
                                        Rectangle()
                                            .frame(height: 200)
                                            .overlay(
                                                Image("world")
                                                    .resizable() // Make the image resizable
                                                    .scaledToFill() // Make the image fill the space of the rectangle
                                                    .clipped() // Clip any excess part of the image
                                                    .opacity(0.9) // Set the image opacity to 0.1
                                            )
                                            .border(Color.white, width: 2) // White border around the rectangle
                                            .background(.clear) // Ensure the rectangle background is transparent
                                         */
                                        Spacer()
                                        
                                        HStack {
                                            
                                            VStack {
                                                
                                                HStack {
                                                    Text("Transit Time")
                                                        .font(.custom("MontserratAlternates-Bold", size: 20))
                                                        .foregroundColor(.white)
                                                    
                                                    Spacer()
                                                    
                                                    Text(object[3])
                                                        .font(.custom("MontserratAlternates-Bold", size: 20))
                                                        .foregroundColor(.white)
                                                }
                                                
                                                HStack {
                                                    Text("Date")
                                                        .font(.custom("MontserratAlternates-Bold", size: 20))
                                                        .foregroundColor(.white)
                                                    
                                                    Spacer()
                                                    
                                                    Text(date)
                                                        .font(.custom("MontserratAlternates-Bold", size: 20))
                                                        .foregroundColor(.white)
                                                }
                                                
                                                HStack {
                                                    Text("Temperature")
                                                        .font(.custom("MontserratAlternates-Bold", size: 20))
                                                        .foregroundColor(.white)
                                                    
                                                    Spacer()
                                                    
                                                    if let temperature = weather.hourlyTemperature {
                                                        Text("\(String(format: "%.1f", temperature))°C")
                                                            .font(.custom("MontserratAlternates-Bold", size: 20))
                                                            .foregroundColor(.white)
                                                    }
                                                }
                                                
                                                HStack {
                                                    Text("Cloud coverage")
                                                        .font(.custom("MontserratAlternates-Bold", size: 20))
                                                        .foregroundColor(.white)
                                                    
                                                    Spacer()
                                                    
                                                    if let cloudCover = weather.hourlyCondition {
                                                        Text("\(String(cloudCover))")
                                                            .font(.custom("MontserratAlternates-Bold", size: 20))
                                                            .foregroundColor(.white)
                                                    }
                                                }
                                                
                                                HStack {
                                                    Text("Precipitation")
                                                        .font(.custom("MontserratAlternates-Bold", size: 20))
                                                        .foregroundColor(.white)
                                                    
                                                    Spacer()
                                                    
                                                    if let precipitation = weather.hourlyPrecipitationChance {
                                                        Text("\(String(format: "%.1f", precipitation)) mm/h")
                                                            .font(.custom("MontserratAlternates-Bold", size: 20))
                                                            .foregroundColor(.white)
                                                    }
                                                }
                                                
                                                HStack {
                                                    Text("Humidity")
                                                        .font(.custom("MontserratAlternates-Bold", size: 20))
                                                        .foregroundColor(.white)
                                                    
                                                    Spacer()
                                                    
                                                    if let humidity = weather.hourlyHumidity {
                                                        Text("\(String(format: "%.1f", humidity))%")
                                                            .font(.custom("MontserratAlternates-Bold", size: 20))
                                                            .foregroundColor(.white)
                                                    }
                                                }
                                                
                                                HStack {
                                                    Image("planet")
                                                        .resizable()
                                                        .scaledToFit()
                                                        .opacity(0.8)
                                                        .clipShape(RoundedRectangle(cornerRadius: 50))
                                                    
                                                    Spacer()
                                                    
                                                    VStack {
                                                        
                                                        Spacer()
                                                        
//                                                        HStack {
//                                                            
//                                                            Button(action: {
//                                                                fetchData()
//                                                                Task {
//                                                                    await weather.fetchWeather(for: location)
//                                                                }
//                                                            }) {
//                                                                Image(systemName: "arrow.clockwise")
//                                                                    .bold()
//                                                            }
//                                                            .padding()
//                                                            .background(Color.clear)
//                                                            .foregroundColor(.white)
//                                                            .cornerRadius(10)
//                                                            .disabled(isLoading || locationManager.coordinates == nil)
//                                                            
//                                                            Spacer()
//                                                        }
                                                        Spacer()
                                                        Spacer()
                                                        Spacer()
                                                        Spacer()
                                                        HStack {
                                                            Image(systemName: "location")
                                                            Text(locationName)
                                                                .foregroundColor(.white)
                                                                .font(.custom("MontserratAlternates-Bold", size: 20))
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
                        .tabViewStyle(.page(indexDisplayMode: .never))
                        .onAppear {
                            opacityValue = 0.7
                        }
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
                    print(apiResponse?.data[0][3])
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

#Preview {
    ContentView()
}
