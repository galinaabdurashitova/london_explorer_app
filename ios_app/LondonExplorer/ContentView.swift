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
    
    var body: some View {
        Group {
            if auth.isSignedIn {
                MainTabView()
                    .environmentObject(networkMonitor)
                    .environmentObject(auth)
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
