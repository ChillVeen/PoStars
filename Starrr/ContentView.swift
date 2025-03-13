//
//  ContentView.swift
//  Stargazing
//
//  Created by Alessandro Rippa on 11/03/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            Tab("NEOs", systemImage: "moon.fill"){
                AsteroidListView()
            }
            Tab("SBos", systemImage: "star.fill"){
                SBListView()
            }
        }
    }
}

#Preview {
    ContentView()
}
