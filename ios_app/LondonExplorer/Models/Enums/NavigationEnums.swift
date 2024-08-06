//
//  NavigationEnums.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 25.07.2024.
//

import Foundation

enum AttractionNavigation: Hashable {
    case info
    case map
}

enum RouteNavigation: Hashable {
    case info(Route)
    case progress(Route)
    case map(Route)
    case finishedRoute(User.FinishedRoute)
}

enum CreateRoutePath: Hashable {
    case routeStops
    case finishCreate([Route.RouteStop], [CodableMKRoute?])
    case savedRoute(Route)
}

enum ProfileNavigation: Hashable {
    case finishedRoutes
}
