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
    @Published var routeName: String
    @Published var routeDescription: String
    //@AppStorage("LONDON_EXPLORER_ROUTE") var savedRoute: Route
    
    init(stops: [Route.RouteStop], pathes: [CodableMKRoute?]) {
        self.route = Route(
            name: "New Route",
            description: "",
            image: stops.count > 0 ? stops[0].attraction.images[0] : UIImage(imageLiteralResourceName: "default"),
            collectables: 0,
            stops: stops
            , pathes: pathes
        )
        //self.savedRoute = self.route
        self.routeName = ""
        self.routeDescription = ""
    }
}
