//
//  NavigationEnums.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 25.07.2024.
//

import Foundation

enum RouteNavigation: Hashable {
    case info(Route)
    case progress(Route)
    case map(Route)
}

enum CreateRoutePath: Hashable {
    case routeStops
    case finishCreate([Route.RouteStop], [CodableMKRoute?])
    case savedRoute(Route)
}

enum ProfileNavigation: Hashable {
    case finishedRoutes
}
