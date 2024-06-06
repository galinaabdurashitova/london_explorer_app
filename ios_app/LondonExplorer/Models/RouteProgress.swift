//
//  RouteProgress.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 31.05.2024.
//

import Foundation
import SwiftUI

struct RouteProgress: Identifiable {
    var id = UUID()
    var route: Route
    var collectables: Int
    var stops: Int
    var user: User?
}
