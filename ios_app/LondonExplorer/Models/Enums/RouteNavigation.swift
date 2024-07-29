//
//  RouteNavigation.swift
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

