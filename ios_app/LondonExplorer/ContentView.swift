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
                noInternet
            } else if auth.isSignedIn {
                MainTabView()
                    .environmentObject(networkMonitor)
                    .environmentObject(auth)
                    .environmentObject(currentRoute)
                    .environmentObject(globalSettings)
                    .environmentObject(awards)
                    .onAppear {
                        launchApp()
                    }
            } else {
                AuthView()
                    .environmentObject(auth)
            }
        }
    }
    
    private var noInternet: some View {
        VStack(spacing: 25) {
            HStack {
                LondonExplorerLogo(scrollOffset: 50)
                Image("Bus3DIcon")
            }
            
            EmptyStateBanner()
        }
        .padding()
    }
    
    private func launchApp() {
        Task {
            currentRoute.getMyRouteProgress(user: auth.profile)
            await awards.getRoutesAwards(user: auth.profile)
        }
    }
}

#Preview {
    ContentView()
}
