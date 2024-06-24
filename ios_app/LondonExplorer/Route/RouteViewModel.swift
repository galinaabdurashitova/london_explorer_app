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
    
    init(route: Binding<Route>) {
        self._route = route
    }
    
    func deleteRoute() {
        savedRoutes.removeAll(where: { $0.id == route.id })
    }
}
