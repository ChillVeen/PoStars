//
//  ContentView.swift
//  Starrr
//
//  Created by Praveen Singh on 27/02/25.
//

import SwiftUI

struct ContentView: View {
    @State private var events: [String: Any] = [:]
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    var body: some View {
        NavigationView {
            VStack {
                if isLoading {
                    ProgressView("Fetching Events...")
                } else if let error = errorMessage {
                    Text("Error: \(error)")
                        .foregroundColor(.red)
                } else if !events.isEmpty {
                    List {
                        ForEach(events.keys.sorted(), id: \.self) { key in
                            VStack(alignment: .leading) {
                                Text(key).font(.headline)
                                Text("\(events[key] ?? "N/A")").font(.subheadline)
                            }
                        }
                    }
                } else {
                    Text("No events to display.")
                }
                
                Button("Fetch Events") {
                    fetchEvents()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            .navigationTitle("Stargazing Events")
            .padding()
        }
    }
    
    private func fetchEvents() {
        isLoading = true
        errorMessage = nil
        
        let request = BodyEventRequest(
            body: "moon",
            longitude: "-122.4194",
            latitude: "37.7749",
            elevation: "10",
            fromDate: "2023-10-01",
            toDate: "2023-10-31",
            time: "12:00:00",
            output: "table"
        )
        
        APIService.shared.fetchBodyEvents(request: request) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let data):
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                            self.events = json
                        }
                    } catch {
                        self.errorMessage = "Failed to parse data."
                    }
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
