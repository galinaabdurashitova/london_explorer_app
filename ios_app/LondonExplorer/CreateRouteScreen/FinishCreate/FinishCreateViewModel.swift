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
    @RoutesStorage(key: "LONDON_EXPLORER_ROUTES") var savedRoutes: [Route]
    
    init(stops: [Route.RouteStop], pathes: [CodableMKRoute?]) {
        self.route = Route(
            dateCreated: Date(),
            name: "",
            description: "",
            image: stops.count > 0 ? stops[0].attraction.images[0] : UIImage(imageLiteralResourceName: "default"),
            collectables: 0,
            stops: stops,
            pathes: pathes
        )
    }
    
    func saveRoute() {
        savedRoutes.append(route)
    }
}
