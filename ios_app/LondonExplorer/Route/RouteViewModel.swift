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
    @RoutesStorage(key: "LONDON_EXPLORER_ROUTES") var savedRoutes: [Route]
    @RoutesStorage(key: "LONDON_EXPLORER_FINISHED_ROUTES") var finishedRoutes: [RouteProgress]
    @CurrentRouteStorage(key: "LONDON_EXPLORER_CURRENT_ROUTE") var savedRouteProgress: RouteProgress?
    
    init(route: Binding<Route>) {
        self._route = route
    }
    
    func deleteRoute() {
        if let current = savedRouteProgress, current.route.id == route.id {
            savedRouteProgress = nil
        }
        finishedRoutes.removeAll(where: { $0.route.id == route.id })
        savedRoutes.removeAll(where: { $0.id == route.id })
    }
}
