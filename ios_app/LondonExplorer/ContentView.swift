//
//  ContentView.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 30.05.2024.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var networkMonitor: NetworkMonitor
    @State var selection = 0
    
    var body: some View {
        TabView (selection: $selection) {
            MainScreenView()
                .environmentObject(networkMonitor)
                .tabItem {
                    Label("Home", systemImage: selection == 0 ? "house.fill" :  "house")
                        .environment(\.symbolVariants, .none)
                }
                .tag(0)
            
            ProgressView()
                .environmentObject(networkMonitor)
                .tabItem {
                    Label("Browse", systemImage: "magnifyingglass")
                        .environment(\.symbolVariants, .none)
                }
                .tag(1)
            
            CreateRouteView()
                .environmentObject(networkMonitor)
                .tabItem {
                    Label("New Route", systemImage: "plus")
                        .environment(\.symbolVariants, .none)
                }
                .tag(2)
            
            ProgressView()
                .environmentObject(networkMonitor)
                .tabItem {
                    Label("Favourites", systemImage: selection == 3 ? "heart.fill" : "heart")
                        .environment(\.symbolVariants, .none)
                }
                .tag(3)
            
            ProgressView()
                .environmentObject(networkMonitor)
                .tabItem {
                    Label("Profile", systemImage: selection == 4 ? "person.fill" : "person")
                        .environment(\.symbolVariants, .none)
                }
                .tag(4)
        }
        .accentColor(Color.redDark)
    }
}

#Preview {
    ContentView()
        .environmentObject(NetworkMonitor())
}
