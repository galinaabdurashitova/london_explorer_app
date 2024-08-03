//
//  RouteViewModel.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 20.06.2024.
//

import Foundation
import SwiftUI

class RouteViewModel: ObservableObject {
    @Published var route: Route
    @CurrentRouteStorage(key: "LONDON_EXPLORER_CURRENT_ROUTE") var savedRouteProgress: RouteProgress?
    
    private var routesService = RoutesService()
    
    init(route: Route) {
        self.route = route
    }
    
    func deleteRoute() {
        Task {
            do {
                try await routesService.deleteRoute(routeId: route.id)
                if let current = savedRouteProgress, current.route.id == route.id {
                    DispatchQueue.main.async {
                        self.savedRouteProgress = nil
                    }
                }
            } catch {
                print("Error deleting route")
            }
        }
    }
}
