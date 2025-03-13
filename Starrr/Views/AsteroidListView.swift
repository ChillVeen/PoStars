//
//  AsteroidListView.swift
//  NasaApiApp
//
//  Created by Praveen Singh on 31/01/25.
//

import SwiftUI

struct AsteroidListView: View {
    @StateObject private var viewModel = AsteroidViewModel()
    @State private var selectedAsteroid: Asteroid?

    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    ProgressView("Loading upcoming asteroids...")
                } else if let errorMessage = viewModel.errorMessage {
                    ContentUnavailableView("Error",
                        systemImage: "exclamationmark.triangle",
                        description: Text(errorMessage))
                } else if viewModel.asteroids.isEmpty {
                    ContentUnavailableView("No Asteroids",
                        systemImage: "magnifyingglass",
                        description: Text("No near-Earth objects detected for the next 7 days"))
                } else {
                    List(viewModel.sortedAsteroids) { asteroid in
                        Button(action: {
                            selectedAsteroid = asteroid
                        }) {
                            AsteroidRow(asteroid: asteroid)
                        }
                        // Remove button styling so the row looks exactly like before
                        .buttonStyle(PlainButtonStyle())
                    }
                    .refreshable {
                        viewModel.fetchAsteroidData()
                    }
                }
            }
            .navigationTitle("NEOs for next 7 Days")
            .toolbar {
                Button(action: { viewModel.fetchAsteroidData() }) {
                    Image(systemName: "arrow.clockwise")
                }
                .disabled(viewModel.isLoading)
            }
        }
        .onAppear {
            if viewModel.asteroids.isEmpty {
                viewModel.fetchAsteroidData()
            }
        }
        // Present the modal for asteroid details
        .sheet(item: $selectedAsteroid) { asteroid in
            AsteroidDetailView(asteroid: asteroid)
        }
    }
}
