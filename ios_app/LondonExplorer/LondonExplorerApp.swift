//
//  LondonExplorerApp.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 30.05.2024.
//

import SwiftUI
import FirebaseCore

@main
struct LondonExplorerApp: App {
    @StateObject var networkMonitor = NetworkMonitor()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(networkMonitor)
        }
    }
}
