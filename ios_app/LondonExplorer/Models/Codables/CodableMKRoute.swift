//
//  CodableMKRoute.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 18.06.2024.
//

import Foundation
import SwiftUI
import MapKit

struct CodableMKRoute: Codable, Hashable {
    var name: String
    var distance: CLLocationDistance
    var expectedTravelTime: TimeInterval
    var polyline: CodableMKPolyline

    init(from route: MKRoute) {
        self.name = route.name
        self.distance = route.distance
        self.expectedTravelTime = route.expectedTravelTime
        self.polyline = CodableMKPolyline(polyline: route.polyline)
    }
}
