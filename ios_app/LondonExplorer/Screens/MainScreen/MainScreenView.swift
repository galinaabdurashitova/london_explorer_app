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
    @EnvironmentObject var awards: AwardsObserver
    @StateObject var friendsFeed: FriendsFeedViewModel
    
    @State var routes: [Route] = MockData.Routes
    
    @State var isLoading: Bool = true
    
    @State private var scrollOffset: CGFloat = 0
    
    private var headerHeight: CGFloat {
        max(50, 120 - scrollOffset)
    }
    
    init() {
        self._friendsFeed = StateObject(wrappedValue: FriendsFeedViewModel())
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
                                OnRouteWidget()
                            if networkMonitor.isConnected {
//                                FriendsOnRouteWidget(friendsProgresses: $friendsOnRoute)
                                SuggestedRoutesCarousel(routes: $routes)
                                FriendsFeed(viewModel: friendsFeed)
                            } else {
                                DownloadedRoutesWidget(routes: $routes)
                            }
                            
                            Spacer()
                        }
                        .padding(.horizontal)
                        .background(
                            GeometryReader { geometry in
                                Color.clear
                                    .preference(key: ScrollOffsetPreferenceKey.self, value: geometry.frame(in: .named("scroll")).minY)
                            }
                        )
                    } else {
                        LoadingView()
                            .padding(.horizontal)
                    }
                }
                .coordinateSpace(name: "scroll")
                .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                    scrollOffset = max(0, -value)
                }
            }
            .padding(.top, 20)
            .toolbar(.visible, for: .tabBar)
            .appNavigation()
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
    MainScreenView()
        .environmentObject(AuthController())
        .environmentObject(NetworkMonitor())
        .environmentObject(CurrentRouteManager())
        .environmentObject(AwardsObserver())
}
