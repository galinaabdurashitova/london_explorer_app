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
    @StateObject var awards = AwardsObserver()
    
    var body: some View {
        Group {
            if !networkMonitor.isConnected {
                VStack(spacing: 25) {
                    HStack {
                        LondonExplorerLogo(scrollOffset: 50)
                        Image("Bus3DIcon")
                    }
                    
                    EmptyStateBanner()
                }
                .padding()
            } else if auth.isSignedIn {
                MainTabView()
                    .environmentObject(networkMonitor)
                    .environmentObject(auth)
                    .environmentObject(currentRoute)
                    .environmentObject(globalSettings)
                    .environmentObject(awards)
                    .task {
                        currentRoute.getMyRouteProgress(user: auth.profile)
                        await awards.getRoutesAwards(user: auth.profile)
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
