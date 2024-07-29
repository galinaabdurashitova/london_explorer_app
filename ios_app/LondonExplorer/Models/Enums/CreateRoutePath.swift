//
//  CreateRoutePath.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 25.07.2024.
//

import Foundation

enum CreateRoutePath: Hashable {
    case routeStops
    case finishCreate([Route.RouteStop], [CodableMKRoute?])
    case savedRoute(Route)
}
