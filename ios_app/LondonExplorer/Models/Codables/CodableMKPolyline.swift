//
//  CodableMKPolyline.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 18.06.2024.
//

import Foundation
import SwiftUI
import MapKit

struct CodableMKPolyline: Codable {
    var coordinates: [CLLocationCoordinate2D]

    init(polyline: MKPolyline) {
        var coords = [CLLocationCoordinate2D]()
        let range = NSRange(location: 0, length: polyline.pointCount)
        polyline.getCoordinates(&coords, range: range)
        self.coordinates = coords
    }

    func toMKPolyline() -> MKPolyline {
        let count = coordinates.count
        var coords = UnsafeMutablePointer<CLLocationCoordinate2D>.allocate(capacity: count)
        coords.initialize(from: coordinates, count: count)
        let polyline = MKPolyline(coordinates: coords, count: count)
        coords.deallocate()
        return polyline
    }

    private enum CodingKeys: String, CodingKey {
        case coordinates
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        coordinates = try container.decode([CLLocationCoordinate2D].self, forKey: .coordinates)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(coordinates, forKey: .coordinates)
    }
}
