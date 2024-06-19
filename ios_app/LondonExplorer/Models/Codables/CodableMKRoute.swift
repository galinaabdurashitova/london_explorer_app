//
//  CodableMKRoute.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 18.06.2024.
//

import Foundation
import SwiftUI
import MapKit

struct CodableMKRoute: Codable {
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

    private enum CodingKeys: String, CodingKey {
        case name
        case distance
        case expectedTravelTime
        case polyline
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        distance = try container.decode(CLLocationDistance.self, forKey: .distance)
        expectedTravelTime = try container.decode(TimeInterval.self, forKey: .expectedTravelTime)
        polyline = try container.decode(CodableMKPolyline.self, forKey: .polyline)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(distance, forKey: .distance)
        try container.encode(expectedTravelTime, forKey: .expectedTravelTime)
        try container.encode(polyline, forKey: .polyline)
    }
}
