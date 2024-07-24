//
//  ContentView.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 30.05.2024.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var networkMonitor: NetworkMonitor
    @EnvironmentObject var auth: AuthController
    
    var body: some View {
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

#Preview {
    ContentView()
        .environmentObject(NetworkMonitor())
        .environmentObject(AuthController())
}
