//
//  TabView.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 23.07.2024.
//

import Foundation
import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var networkMonitor: NetworkMonitor
    @EnvironmentObject var auth: AuthController
    @State var tabSelection = 0
    
    var body: some View {
        TabView (selection: $tabSelection) {
            MainScreenView()
                .environmentObject(networkMonitor)
                .tabItem {
                    Label("Home", systemImage: tabSelection == 0 ? "house.fill" :  "house")
                        .environment(\.symbolVariants, .none)
                }
                .tag(0)
            
//            ProgressView()
//                .environmentObject(networkMonitor)
//                .tabItem {
//                    Label("Browse", systemImage: "magnifyingglass")
//                        .environment(\.symbolVariants, .none)
//                }
//                .tag(1)
            
            CreateRouteView(tabSelection: $tabSelection)
                .environmentObject(networkMonitor)
                .environmentObject(auth)
                .tabItem {
                    Label("New Route", systemImage: "plus")
                        .environment(\.symbolVariants, .none)
                }
                .tag(2)
            
//            ProgressView()
//                .environmentObject(networkMonitor)
//                .tabItem {
//                    Label("Favourites", systemImage: tabSelection == 3 ? "heart.fill" : "heart")
//                        .environment(\.symbolVariants, .none)
//                }
//                .tag(3)
            
            ProfileView(user: auth.profile, tabSelection: $tabSelection)
                .environmentObject(networkMonitor)
                .environmentObject(auth)
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
    MainTabView()
        .environmentObject(NetworkMonitor())
        .environmentObject(AuthController())
}
