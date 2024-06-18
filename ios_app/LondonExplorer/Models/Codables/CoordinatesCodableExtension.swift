//
//  CoordinatesCodableExtension.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 18.06.2024.
//

import Foundation
import SwiftUI
import CoreLocation

extension CLLocationCoordinate2D: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let latitude = try container.decode(CLLocationDegrees.self, forKey: .latitude)
        let longitude = try container.decode(CLLocationDegrees.self, forKey: .longitude)
        self.init(latitude: latitude, longitude: longitude)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(latitude, forKey: .latitude)
        try container.encode(longitude, forKey: .longitude)
    }

    private enum CodingKeys: String, CodingKey {
        case latitude
        case longitude
    }
}
