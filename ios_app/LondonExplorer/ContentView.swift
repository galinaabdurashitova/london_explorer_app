//
//  ContentView.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 30.05.2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject var networkMonitor = NetworkMonitor()
    @StateObject var auth = AuthController()
    @StateObject var currentRoute = CurrentRouteManager()
    @StateObject var globalSettings = GlobalSettings()
    
    var body: some View {
        Group {
            if auth.isSignedIn {
                MainTabView()
                    .environmentObject(networkMonitor)
                    .environmentObject(auth)
                    .environmentObject(currentRoute)
                    .environmentObject(globalSettings)
                    .onAppear {
                        currentRoute.getMyRouteProgress(user: auth.profile)
                    }
            } else {
                AuthView()
                    .environmentObject(auth)
            }
        }
    }
}

#Preview {
    ContentView()
}
