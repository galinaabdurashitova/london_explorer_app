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
    @EnvironmentObject var currentRoute: CurrentRouteManager
    @Binding var tabSelection: Int
    @State var routes: [Route] = MockData.Routes
    @State var friendsFeed: [FriendUpdate] = MockData.FriendsFeed
    @State var onRoute: RouteProgress = MockData.RouteProgress[0]
    @State var friendsOnRoute: [RouteProgress] = MockData.RouteProgress
    @State var isLoading: Bool = true
    
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
                    if !isLoading {
                        VStack(spacing: 25) {
                                OnRouteWidget(tabSelection: $tabSelection)
                            if networkMonitor.isConnected {
//                                FriendsOnRouteWidget(friendsProgresses: $friendsOnRoute)
                                SuggestedRoutesCarousel(routes: $routes)
//                                FriendsFeed(friendsFeed: $friendsFeed)
                            } else {
                                DownloadedRoutesWidget(routes: $routes)
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
                case .progress(let route):
                    OnRouteView(route: route, user: auth.profile, savedRouteProgress: currentRoute.routeProgress)
                case .map(let route):
                    MapRouteView(route: route)
                case .finishedRoute(let finishedRoute):
                    if let route = finishedRoute.route { RouteView(route: route) }
                }
            }
            .navigationDestination(for: RouteProgress.self) { routeProgress in
                OnRouteView(routeProgress: routeProgress)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.isLoading = false
            }
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
    MainScreenView(tabSelection: .constant(0))
        .environmentObject(AuthController())
        .environmentObject(NetworkMonitor())
        .environmentObject(CurrentRouteManager())
}
