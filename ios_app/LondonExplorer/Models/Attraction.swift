//
//  Attraction.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 08.06.2024.
//

import Foundation
import SwiftUI
import MapKit

struct Attraction: Identifiable, Equatable, Codable, Hashable {
    var id: String
    var name: String
    var shortDescription: String
    var fullDescription: String
    var address: String
    var coordinates: CLLocationCoordinate2D
    var imageURLs: [String] = []
    var categories: [Category]
}
