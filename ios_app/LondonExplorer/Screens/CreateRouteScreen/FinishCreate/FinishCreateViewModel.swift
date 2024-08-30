//
//  FinishCreateViewModel.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 17.06.2024.
//

import Foundation
import SwiftUI
import MapKit

class FinishCreateViewModel: ObservableObject {
    @Published var route: Route
    @Published var isSaving: Bool = false
    
    private var routesManager: RoutesStorageManager = RoutesStorageManager()
    
    init(stops: [Route.RouteStop], pathes: [CodableMKRoute?], collectables: [Route.RouteCollectable]) {
        self.route = Route(
            dateCreated: Date(),
            userCreated: "",
            name: "",
            description: "",
            collectables: collectables,
            stops: stops,
            pathes: pathes
        )
    }
    
    @MainActor
    func saveRoute(userId: String)  {
        self.isSaving = true
        self.route.userCreated = userId
        routesManager.saveRoute(route: route)
        self.isSaving = false
    }
}
