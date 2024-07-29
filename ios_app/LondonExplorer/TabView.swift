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
    
    @UserStorage(key: "LONDON_EXPLORER_USERS") var users: [User]
    @RoutesStorage(key: "LONDON_EXPLORER_ROUTES") var savedRoutes: [Route]
    @CurrentRouteStorage(key: "LONDON_EXPLORER_CURRENT_ROUTE") var savedRouteProgress: RouteProgress?
    @RoutesStorage(key: "LONDON_EXPLORER_FINISHED_ROUTES") var finishedRoutes: [RouteProgress]
    
    @State var routeProgress: RouteProgress?
    
    var body: some View {
        TabView (selection: $tabSelection) {
            MainScreenView()
                .environmentObject(networkMonitor)
                .environmentObject(auth)
                .tabItem {
                    Label("Home", systemImage: tabSelection == 0 ? "house.fill" :  "house")
                        .environment(\.symbolVariants, .none)
                }
                .tag(0)
            
            ScrollView {
                VStack {
//                    Text("Users")
//                    ForEach(users) { user in
//                        HStack (spacing: 5) {
//                            Text(user.id)
//                            Text(user.name)
//                            Text(user.userName)
//                            Text(user.finishedRoutes.description)
//                        }
//                    }
//                    
//                    Text("Saved routes")
//                    ForEach(savedRoutes, id: \.id) { route in
//                        HStack {
//                            RouteCard(route: .constant(route), size: .S)
//                        }
//                    }
//                    
//                    Text("Finished routes")
//                    ForEach(finishedRoutes, id: \.id) { route in
//                        HStack {
//                            RouteCard(route: .constant(route.route), size: .S)
//                        }
//                    }
                    
                    Text("Route progress")
                    if let savedRouteProgress = routeProgress {
                        RouteProgressView(routeProgress: .constant(savedRouteProgress))
                    }
                }
                .padding()
                .onAppear {
                    routeProgress = savedRouteProgress
                }
            }
                .environmentObject(networkMonitor)
                .tabItem {
                    Label("Browse", systemImage: "magnifyingglass")
                        .environment(\.symbolVariants, .none)
                }
                .tag(1)
            
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
