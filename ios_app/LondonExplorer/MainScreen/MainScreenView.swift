//
//  MainScreenView.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 30.05.2024.
//

import Foundation
import SwiftUI

struct MainScreenView: View {
    @EnvironmentObject var networkMonitor: NetworkMonitor
    @EnvironmentObject var auth: AuthController
    @State var routes: [Route] = MockData.Routes
    @State var friendsFeed: [FriendUpdate] = MockData.FriendsFeed
    @State var onRoute: RouteProgress = MockData.RouteProgress[0]
    @State var friendsOnRoute: [RouteProgress] = MockData.RouteProgress
    @State var isLoading: Bool = false
    
    
    
    @CurrentRouteStorage(key: "LONDON_EXPLORER_CURRENT_ROUTE") var routeProgress: RouteProgress?
    @State var currentRoute: RouteProgress?
    
    
    @State private var scrollOffset: CGFloat = 0
    
    private var headerHeight: CGFloat {
        max(50, 120 - scrollOffset)
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                MainScreenHeader(scrollOffset: scrollOffset * 1.6, headerHeight: headerHeight)
                    .frame(height: headerHeight)
                
                ScrollView(showsIndicators: false) {
                    Spacer()
                    if isLoading {
                        VStack(spacing: 25) {
                            if let currentRoute = currentRoute {
                                OnRouteWidget(currentRoute: Binding(
                                    get: { currentRoute },
                                    set: { _ in }
                                ))
                                    .environmentObject(auth)
                            }
                            if networkMonitor.isConnected {
//                                FriendsOnRouteWidget(friendsProgresses: $friendsOnRoute)
//                                    .environmentObject(auth)
                                SuggestedRoutesCarousel(routes: $routes)
                                    .environmentObject(auth)
//                                FriendsFeed(friendsFeed: $friendsFeed)
                            } else {
                                DownloadedRoutesWidget(routes: $routes)
                                    .environmentObject(auth)
                            }
                            
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        .background(
                            GeometryReader { geometry in
                                Color.clear
                                    .preference(key: ScrollOffsetPreferenceKey.self, value: geometry.frame(in: .named("scroll")).minY)
                            }
                        )
                    } else {
                        LoadingView()
                            .padding(.horizontal, 20)
                    }
                }
                .coordinateSpace(name: "scroll")
                .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                    scrollOffset = max(0, -value)
                }
            }
            .padding(.top, 20)
            .toolbar(.visible, for: .tabBar)
            .navigationDestination(for: RouteNavigation.self) { value in
                switch value {
                case .info(let route):
                    RouteView(route: route)
                        .environmentObject(auth)
                case .progress(let route):
                    OnRouteView(route: route)
                        .environmentObject(auth)
                case .map(let route):
                    MapRouteView(route: route)
                }
            }
            .navigationDestination(for: RouteProgress.self) { routeProgress in
                OnRouteView(routeProgress: Binding(
                    get: { routeProgress },
                    set: { _ in }
                ))
                    .environmentObject(auth)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.isLoading = true
            }
        }
        
        .onAppear {
            currentRoute = routeProgress
        }
    }
}

struct ScrollOffsetPreferenceKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value += nextValue()
    }
}


#Preview {
    MainScreenView()
        .environmentObject(AuthController())
        .environmentObject(NetworkMonitor())
}
