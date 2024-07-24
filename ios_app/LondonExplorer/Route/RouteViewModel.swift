//
//  RouteViewModel.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 20.06.2024.
//

import Foundation
import SwiftUI

class RouteViewModel: ObservableObject {
    @Binding var route: Route
    @CurrentRouteStorage(key: "LONDON_EXPLORER_CURRENT_ROUTE") var savedRouteProgress: RouteProgress?
    
    private var routesService = RoutesService()
    
    init(route: Binding<Route>) {
        self._route = route
    }
    
    func deleteRoute() {
        Task {
            do {
                try await routesService.deleteRoute(routeId: route.id)
                if let current = savedRouteProgress, current.route.id == route.id {
                    savedRouteProgress = nil
                }
            } catch {
                print("Error deleting route")
            }
        }
    }
}
