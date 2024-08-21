//
//  AppNavigation.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 21.08.2024.
//

import Foundation
import SwiftUI

extension View {
    func appNavigation(tab: Binding<Int>) -> some View {
        self
            .navigationDestination(for: RouteNavigation.self) { value in
                switch value {
                case .info(let route):
                    RouteView(route: route)
                case .progress(let route, let user, let routeProgress):
                    OnRouteView(route: route, user: user, savedRouteProgress: routeProgress)
                case .map(let route):
                    MapRouteView(route: route)
                case .finishedRoute(let finishedRoute):
                    if let route = finishedRoute.route { RouteView(route: route) }
                }
            }
            .navigationDestination(for: ProfileNavigation.self) { value in
                switch value {
                case .profile(let user):
                    ProfileView(user: user, tabSelection: tab)
                case .finishedRoutes(let user):
                    FinishedRoutesView(user: user)
                case .collectables(let user):
                    ProfileCollectablesView(user: user)
                case .awards(let user):
                    AwardsView(user: user)
                case .friends(let user):
                    FriendsView(user: user)
                case .settings:
                    SettingsView()
                }
            }
    }
}
