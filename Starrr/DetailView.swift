import SwiftUI

struct DetailView: View {
    let object: [String]
    let fields: [String]
    @State private var showingInfo: String? = nil
    
    // Add parameter descriptions
    let parameterInfo: [String: String] = [
        "Rise time": "The time it takes for the object to rise above the horizon after the observer's local horizon. This value depends on the observer's location and the object's current position relative to the Earth.",
        "Set time": "The time when the object sets below the horizon after being visible in the sky. This value is also location-dependent and depends on the object's position relative to the observer.",
        "Transit time": "The time when the object crosses the observer's local meridian (an imaginary line running from north to south through the observer's location). It's the moment the object is highest in the sky.",
        "Max. time observable": "The maximum time the object is observable, usually referring to the period between rise time and set time when the object is visible in the sky.",
        "Vmag": "Visual magnitude is the measure of the object's brightness as seen from Earth in the visible spectrum. A smaller value indicates a brighter object, with negative values indicating exceptionally bright objects.",
        "Dec.": "Declination is a celestial coordinate that is similar to latitude on Earth, measuring the angular distance of an object north or south of the celestial equator. It helps determine the object's position in the sky.",
        "R.A.": "Right Ascension is a celestial coordinate that corresponds to the object's angular distance measured eastward along the celestial equator, similar to longitude on Earth. It is one of the coordinates used to pinpoint the location of astronomical objects in the sky.",
        "Helio. range (au)": "Heliocentric distance is the distance between the object and the Sun, measured in Astronomical Units (AU). 1 AU is the average distance from the Earth to the Sun, approximately 93 million miles (150 million kilometers).",
        "Topo. range (au)": "Topocentric distance is the distance between the object and the observer's location on Earth, measured in Astronomical Units (AU)."
    ]

    var body: some View {
        List {
            Section(header: Text("Object Details")) {
                ForEach(0..<object.count, id: \.self) { index in
                    if fields[index] == "Rise time" ||
                        fields[index] == "Set time" ||
                        fields[index] == "Transit time" ||
                        fields[index] == "Max. time observable" ||
                        fields[index] == "Vmag" ||
                        fields[index] == "Dec." ||
                        fields[index] == "R.A." ||
                        fields[index] == "Helio. range (au)" ||
                        fields[index] == "Topo. range (au)" {
                        
                        HStack {
                            VStack(alignment: .leading) {
                                Text(fields[index])
                                    .font(.headline)
                                Text(object[index])
                                    .font(.subheadline)
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                showingInfo = fields[index]
                            }) {
                                Image(systemName: "info.circle")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle(object[1]) // Full name
        .preferredColorScheme(.dark)
        .alert("Parameter Information", isPresented: .constant(showingInfo != nil)) {
            Button("OK") {
                showingInfo = nil
            }
        } message: {
            if let info = showingInfo,
               let description = parameterInfo[info] {
                Text(description)
            } else {
                Text("No information available")
            }
        }
    }
}

// End of file
