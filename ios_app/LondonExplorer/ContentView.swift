//
//  ContentView.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 30.05.2024.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var networkMonitor: NetworkMonitor
    @State var tabSelection = 0
    
    @RoutesStorage(key: "LONDON_EXPLORER_ROUTES") var savedRoutes: [Route]
    
    var body: some View {
        TabView (selection: $tabSelection) {
            MainScreenView()
                .environmentObject(networkMonitor)
                .tabItem {
                    Label("Home", systemImage: tabSelection == 0 ? "house.fill" :  "house")
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
            
            CreateRouteView(tabSelection: $tabSelection)
                .environmentObject(networkMonitor)
                .tabItem {
                    Label("New Route", systemImage: "plus")
                        .environment(\.symbolVariants, .none)
                }
                .tag(2)
            
            ProgressView()
                .environmentObject(networkMonitor)
                .tabItem {
                    Label("Favourites", systemImage: tabSelection == 3 ? "heart.fill" : "heart")
                        .environment(\.symbolVariants, .none)
                }
                .tag(3)
            
            ProfileView()
                .environmentObject(networkMonitor)
                .tabItem {
                    Label("Profile", systemImage: tabSelection == 4 ? "person.fill" : "person")
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
