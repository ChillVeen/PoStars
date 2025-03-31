//
//  MainView.swift
//  Starrr
//
//  Created by DWA on 19/03/25.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        
        TabView {
            
            ContentView()
                .tabItem {
                    Label("NEOs", systemImage: "globe.central.south.asia.fill")
                }
            
            ContentView2()
                .tabItem {
                    Label("Comets", systemImage: "star.circle.fill")
                }
            
            ContentView3()
                .tabItem {
                    Label("PHAs", systemImage: "globe.asia.australia")
                }
        }
    }
}

#Preview {
    MainView()
}
