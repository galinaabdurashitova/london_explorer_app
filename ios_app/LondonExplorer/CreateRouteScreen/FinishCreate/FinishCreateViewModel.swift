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
    
    private var routesService = RoutesService()
    
    init(stops: [Route.RouteStop], pathes: [CodableMKRoute?]) {
        self.route = Route(
            dateCreated: Date(),
            userCreated: Route.UserCreated(id: ""),
            name: "",
            description: "",
            image: stops.count > 0 ? stops[0].attraction.images[0] : UIImage(imageLiteralResourceName: "default"),
            collectables: 0,
            stops: stops,
            pathes: pathes
        )
    }
    
    func saveRoute(userId: String, userName: String) {
        route.userCreated = Route.UserCreated(id: userId, name: userName)
        
        Task {
            do {
                try await routesService.createRoute(newRoute: route)
            } catch {
                print("Error saving route")
            }
        }
    }
}
