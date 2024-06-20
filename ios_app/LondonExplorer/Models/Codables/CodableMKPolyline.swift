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

    // Initialize from an MKPolyline
    init(polyline: MKPolyline) {
        let count = polyline.pointCount
        var coords = [CLLocationCoordinate2D](repeating: kCLLocationCoordinate2DInvalid, count: count)
        polyline.getCoordinates(&coords, range: NSRange(location: 0, length: count))
        self.coordinates = coords
    }

    // Convert back to MKPolyline
    func toMKPolyline() -> MKPolyline {
        return MKPolyline(coordinates: coordinates, count: coordinates.count)
    }

//    // Codable compliance
//    private enum CodingKeys: String, CodingKey {
//        case coordinates
//    }
//
//    // Decoding the coordinates array
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        coordinates = try container.decode([CLLocationCoordinate2D].self, forKey: .coordinates)
//    }
//
//    // Encoding the coordinates array
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(coordinates, forKey: .coordinates)
//    }
}
