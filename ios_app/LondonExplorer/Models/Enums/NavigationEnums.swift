//
//  NavigationEnums.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 25.07.2024.
//

import Foundation
import SwiftUI
import MapKit

enum AttractionNavigation: Hashable {
    case info
    case map
}

enum RouteNavigation: Hashable {
    case info(Route)
    case progress(Route, User, RouteProgress?)
    case map(Route)
    case finishedRoute(User.FinishedRoute)
}

enum CreateRoutePath: Hashable {
    case routeStops
    case finishCreate([Route.RouteStop], [CodableMKRoute?], [Route.RouteCollectable])
    case savedRoute(Route)
}

enum ProfileNavigation: Hashable {
    case profile(User)
    case finishedRoutes(User)
    case collectables(User)
    case awards(User)
    case friends(User)
    case settings
}
