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
    var imageURLs: [String]
    var categories: [Category]
    
    init(id: String, name: String, shortDescription: String, fullDescription: String, address: String, coordinates: CLLocationCoordinate2D, imageURLs: [String], categories: [Category]) {
        self.id = id
        self.name = name
        self.shortDescription = shortDescription
        self.fullDescription = fullDescription
        self.address = address
        self.coordinates = coordinates
        self.imageURLs = imageURLs
        self.categories = categories
    }
    
    static func == (lhs: Attraction, rhs: Attraction) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(shortDescription)
        hasher.combine(fullDescription)
        hasher.combine(address)
        hasher.combine(coordinates.latitude)
        hasher.combine(coordinates.longitude)
        hasher.combine(imageURLs)
        hasher.combine(categories)
    }
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case shortDescription
        case fullDescription
        case address
        case coordinates
        case imageURLs
        case categories
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.shortDescription = try container.decode(String.self, forKey: .shortDescription)
        self.fullDescription = try container.decode(String.self, forKey: .fullDescription)
        self.address = try container.decode(String.self, forKey: .address)
        self.coordinates = try container.decode(CLLocationCoordinate2D.self, forKey: .coordinates)
        self.imageURLs = try container.decode([String].self, forKey: .imageURLs)
        self.categories = try container.decode([Category].self, forKey: .categories)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(shortDescription, forKey: .shortDescription)
        try container.encode(fullDescription, forKey: .fullDescription)
        try container.encode(address, forKey: .address)
        try container.encode(coordinates, forKey: .coordinates)
        try container.encode(imageURLs, forKey: .imageURLs)
        try container.encode(categories, forKey: .categories)
    }
}
