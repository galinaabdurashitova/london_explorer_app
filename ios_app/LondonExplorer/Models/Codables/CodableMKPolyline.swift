//
//  CodableMKPolyline.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 18.06.2024.
//

import Foundation
import SwiftUI
import MapKit


struct CodableMKPolyline: Codable, Hashable {
    var coordinates: [CLLocationCoordinate2D]

    init(polyline: MKPolyline) {
        let count = polyline.pointCount
        var coords = [CLLocationCoordinate2D](repeating: kCLLocationCoordinate2DInvalid, count: count)
        polyline.getCoordinates(&coords, range: NSRange(location: 0, length: count))
        self.coordinates = coords
    }

    func toMKPolyline() -> MKPolyline {
        return MKPolyline(coordinates: coordinates, count: coordinates.count)
    }
}
