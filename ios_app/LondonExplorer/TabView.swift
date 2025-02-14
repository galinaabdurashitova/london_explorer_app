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
    
    @Binding var isAppLoading: Bool
    
    var body: some View {
        if isAppLoading {
            appLoader
        } else {
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
                
                FavouritesView(user: auth.profile)
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
                if !awards.newAwards.isEmpty {
                    AwardPopup()
                }
            }
        }
    }
    
    private var appLoader: some View {
        VStack(spacing: 0) {
            MainScreenHeader(scrollOffset: 0, headerHeight: 120)
                .frame(height: 120)
            
            ScrollView(showsIndicators: false) {
                Spacer()
                LoadingView()
                    .padding(.horizontal)
            }
            .scrollDisabled(true)
            .padding(.top)
        }
        .padding(.top, 20)
    }
}

#Preview {
    MainTabView(isAppLoading: .constant(false))
        .environmentObject(NetworkMonitor())
        .environmentObject(AuthController())
        .environmentObject(CurrentRouteManager())
        .environmentObject(GlobalSettings())
        .environmentObject(AwardsObserver())
}
