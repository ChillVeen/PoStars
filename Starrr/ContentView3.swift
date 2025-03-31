//
//  COntentView3.swift
//  Starrr
//
//  Created by DWA on 18/03/25.
//


import SwiftUI
import CoreLocation
import WeatherKit

// MARK: - Data Models

// MARK: - Main View
struct ContentView3: View {
    
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
    @State var particleCount: Int = 100
    
    @State private var showView = true
    //    var particleCount: Int {
//        
//        let condition = weather.hourlyCondition ?? "Unknown"
//        
//        switch condition {
//        case "Blowing Dust":
//            return 10
//        case "Clear":
//            return 10
//        case "Cloudy":
//            return 30
//        case "Foggy":
//            return 80
//        case "Haze":
//            return 90
//        case "Mostly Clear":
//            return 20
//        case "Mostly Cloudy":
//            return 40
//        case "Partly Cloudy":
//            return 50
//        case "Smoky":
//            return 60
//        default:
//            return 3
//        }
//    }
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
                                        
                                        HStack {
                                            Spacer()
                                            Text(object[1])
                                                .font(.custom("MontserratAlternates-Bold", size: 30))
                                                .foregroundStyle(Color.white)
                                        }
                                        
                                        
                                        HStack {
                                            
                                            Spacer()
                                            
                                            Image(systemName: "location")
                                            
                                            Text(locationName)
                                                .foregroundColor(.white)
                                                .font(.custom("MontserratAlternates-Bold", size: 15))
                                                .padding(.trailing, 40)
                                            
                                            
                                        }
                                        ZStack{
                                            
                                            HStack{
                                                
                                                VStack{
                                                    
                                                    Text("Potential")
                                                        .foregroundStyle(.white)
                                                        .font(.custom("MontserratAlternates-Bold", size: 30))
                                                    
                                                    Text("Hazardous")
                                                        .font(.custom("MontserratAlternates-Bold", size: 30))
                                                        .foregroundStyle(.white)
                                                }
                                                
                                                Text("| ASTEROIDS")
                                                    .font(.custom("MontserratAlternates-Bold", size: 40))
                                                    .foregroundStyle(.white)
                                                    .lineLimit(1)
                                            }
                                            .rotationEffect(Angle(degrees: 270))
                                            .offset(x: -145)
                                            .fixedSize(horizontal: true, vertical: false)
                                            
                                            
                                            HStack{
                                                
                                                Spacer()
                                                
                                                VStack {
                                                
                                                        if showView {
                                                            
                                                            CreativeCoding(creativeCoding: ContentView3())
                                                                .padding(4)
                                                                .background(
                                                                    Rectangle()
                                                                        .stroke(Color.white, lineWidth: 3)
                                                                )
                                                        } else {
                                                            Rectangle()
                                                                .foregroundStyle(Color.black)
                                                        }
                                                    
                                                    VStack {
                                                        
                                                        HStack {
                                                            Text("Transit Time")
                                                                .font(.custom("MontserratAlternates-Bold", size: 16))
                                                                .foregroundColor(.white)
                                                            
                                                            Spacer()
                                                            
                                                            Text(object[3])
                                                                .font(.custom("MontserratAlternates-Bold", size: 16))
                                                                .foregroundColor(.white)
                                                        }
                                                        
                                                        HStack {
                                                            Text("Date")
                                                                .font(.custom("MontserratAlternates-Bold", size: 16))
                                                                .foregroundColor(.white)
                                                            
                                                            Spacer()
                                                            
                                                            Text(date)
                                                                .font(.custom("MontserratAlternates-Bold", size: 16))
                                                                .foregroundColor(.white)
                                                        }
                                                        
                                                        HStack {
                                                            Text("Temperature")
                                                                .font(.custom("MontserratAlternates-Bold", size: 16))
                                                                .foregroundColor(.white)
                                                            
                                                            Spacer()
                                                            
                                                            if let temperature = weather.hourlyTemperature {
                                                                Text("\(String(format: "%.1f", temperature))°C")
                                                                    .font(.custom("MontserratAlternates-Bold", size: 16))
                                                                    .foregroundColor(.white)
                                                            }
                                                        }
                                                        
                                                        HStack {
                                                            Text("Cloud coverage")
                                                                .font(.custom("MontserratAlternates-Bold", size: 16))
                                                                .foregroundColor(.white)
                                                            
                                                            Spacer()
                                                            
                                                            if let cloudCover = weather.hourlyCondition {
                                                                Text("\(String(cloudCover))")
                                                                    .font(.custom("MontserratAlternates-Bold", size: 16))
                                                                    .foregroundColor(.white)
                                                            }
                                                        }
                                                        
                                                        HStack {
                                                            Text("Precipitation")
                                                                .font(.custom("MontserratAlternates-Bold", size: 16))
                                                                .foregroundColor(.white)
                                                            
                                                            Spacer()
                                                            
                                                            if let precipitation = weather.hourlyPrecipitationChance {
                                                                Text("\(String(format: "%.1f", precipitation)) mm/h")
                                                                    .font(.custom("MontserratAlternates-Bold", size: 16))
                                                                    .foregroundColor(.white)
                                                            }
                                                        }
                                                        
                                                        HStack {
                                                            Text("Humidity")
                                                                .font(.custom("MontserratAlternates-Bold", size: 16))
                                                                .foregroundColor(.white)
                                                            
                                                            Spacer()
                                                            
                                                            if let humidity = weather.hourlyHumidity {
                                                                Text("\(String(format: "%.1f", humidity))%")
                                                                    .font(.custom("MontserratAlternates-Bold", size: 16))
                                                                    .foregroundColor(.white)
                                                            }
                                                        }
                                                        
                                                    }
                                                    
                                                }
                                                .frame(width: 270)
                                            }
                                            .offset(x: -50)
                                        }
                                        
                                    }
                                }
                            }
                        }
                        .tabViewStyle(.page(indexDisplayMode: .never))
                        .onAppear {
                            opacityValue = 0.65
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
                            
                            updateValues()

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
    
    private func updateValues() {
        
        switch weather.hourlyCondition {
        case "Blowing Dust":
            particleCount = 10
        case "Clear":
            particleCount = 10
        case "Cloudy":
            particleCount = 30
        case "Foggy":
            particleCount = 80
        case "Haze":
            particleCount = 90
        case "Mostly Clear":
            particleCount = 20
        case "Mostly Cloudy":
            particleCount = 40
        case "Partly Cloudy":
            particleCount = 50
        case "Smoky":
            particleCount = 60
        default:
            particleCount = 3
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
        "https://ssd-api.jpl.nasa.gov/sbwobs.api?lat=\(lat)&lon=\(lon)&obs-time=\(currentDate)&maxoutput=5&output-sort=vmag&sb-group=pha"
        
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
                    print(apiResponse?.data[0][3] as Any)
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
    ContentView3()
}
