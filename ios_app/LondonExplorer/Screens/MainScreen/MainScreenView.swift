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
    @StateObject var suggestedRoutes: SuggestedRoutesViewModel
    
    @State private var scrollOffset: CGFloat = 0
    
    private var headerHeight: CGFloat {
        max(50, 120 - scrollOffset)
    }
    
    init() {
        self._friendsFeed = StateObject(wrappedValue: FriendsFeedViewModel())
        self._suggestedRoutes = StateObject(wrappedValue: SuggestedRoutesViewModel())
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                MainScreenHeader(scrollOffset: scrollOffset * 1.6, headerHeight: headerHeight)
                    .frame(height: headerHeight)
                
                ScrollView(showsIndicators: false) {
                    Spacer()
                    VStack(spacing: 25) {
                        OnRouteWidget()
                        
                        if networkMonitor.isConnected {
                            SuggestedRoutesCarousel(viewModel: suggestedRoutes)
                            FriendsFeed(viewModel: friendsFeed)
                        } else {
                            DownloadedRoutesWidget()
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
