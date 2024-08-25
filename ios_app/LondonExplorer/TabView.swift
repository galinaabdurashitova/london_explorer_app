//
//  TabView.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 23.07.2024.
//

import Foundation
import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var auth: AuthController
    @EnvironmentObject var globalSettings: GlobalSettings
    @EnvironmentObject var awards: AwardsObserver
    
    var body: some View {
        TabView (selection: $globalSettings.tabSelection) {
            MainScreenView()
                .onAppear {
                    awards.checkAward(for: .loggedIn, user: auth.profile)
                }
                .tabItem {
                    Label("Home", systemImage: globalSettings.tabSelection == 0 ? "house.fill" :  "house")
                        .environment(\.symbolVariants, .none)
                }
                .tag(0)
            
            SearchView()
                .tabItem {
                    Label("Browse", systemImage: "magnifyingglass")
                        .environment(\.symbolVariants, .none)
                }
                .tag(1)
            
            CreateRouteView()
                .tabItem {
                    Label("New Route", systemImage: "plus")
                        .environment(\.symbolVariants, .none)
                }
                .tag(2)
            
            TestStorageView()
                .tabItem {
                    Label("Favourites", systemImage: globalSettings.tabSelection == 3 ? "heart.fill" : "heart")
                        .environment(\.symbolVariants, .none)
                }
                .tag(3)
            
            MyProfileView()
                .tabItem {
                    Label("Profile", systemImage: globalSettings.tabSelection == 4 ? "person.fill" : "person")
                        .environment(\.symbolVariants, .none)
                }
                .tag(4)
        }
        .accentColor(Color.redDark)
        .overlay {
            if !awards.newAwards.isEmpty /*&& !auth.isFetchingUser*/ {
                AwardPopup()
            }
        }
    }
}

#Preview {
    MainTabView()
        .environmentObject(NetworkMonitor())
        .environmentObject(AuthController())
        .environmentObject(CurrentRouteManager())
        .environmentObject(GlobalSettings())
        .environmentObject(AwardsObserver())
}
