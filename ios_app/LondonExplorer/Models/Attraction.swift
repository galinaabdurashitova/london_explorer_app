//
//  Attraction.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 08.06.2024.
//

import Foundation
import SwiftUI
import MapKit

struct Attraction: Identifiable, Equatable, Codable {
    var id = UUID()
    var name: String
    var shortDescription: String
    var fullDescription: String
    var address: String
    var coordinates: CLLocationCoordinate2D
    var images: [UIImage] = []
    var categories: [Category]
    
    static func == (lhs: Attraction, rhs: Attraction) -> Bool {
        return lhs.id == rhs.id
    }
    
    enum Category: String, CaseIterable, Identifiable, Codable {
        var id: String { self.rawValue }
        
        case historical = "Historical"
        case museums = "Museums"
        case entertainment = "Entertainment"
        case parks = "Parks"
        case markets = "Markets"
        case pubs = "Pubs"
        case restaurants = "Restaurants"
        case unique = "Unique"
        case hotels = "Hotels"
        case mustsee = "Must-See"
        case cultural = "Cultural"
        case shopping = "Shopping"
    
        var colour: Color {
            switch self {
            case .historical:
                return Color.blueAccent
            case .museums:
                return Color.redAccent
            case .entertainment:
                return Color.yellowAccent
            case .parks:
                return Color.greenAccent
            case .markets:
                return Color.blueAccent
            case .pubs:
                return Color.redAccent
            case .restaurants:
                return Color.yellowAccent
            case .unique:
                return Color.greenAccent
            case .hotels:
                return Color.blueAccent
            case .mustsee:
                return Color.redAccent
            case .cultural:
                return Color.yellowAccent
            case .shopping:
                return Color.greenAccent
            }
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case shortDescription
        case fullDescription
        case address
        case coordinates
        case images
        case categories
    }
    
    init(id: UUID = UUID(), name: String, shortDescription: String, fullDescription: String, address: String, coordinates: CLLocationCoordinate2D, images: [UIImage], categories: [Category]) {
        self.id = id
        self.name = name
        self.shortDescription = shortDescription
        self.fullDescription = fullDescription
        self.address = address
        self.coordinates = coordinates
        self.images = images
        self.categories = categories
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(UUID.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.shortDescription = try container.decode(String.self, forKey: .shortDescription)
        self.fullDescription = try container.decode(String.self, forKey: .fullDescription)
        self.address = try container.decode(String.self, forKey: .address)
        self.coordinates = try container.decode(CLLocationCoordinate2D.self, forKey: .coordinates)
        self.images = (try container.decode([Data].self, forKey: .images)).compactMap { UIImage(data: $0) }
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
        try container.encode(images.compactMap { $0.jpegData(compressionQuality: 1.0) }, forKey: .images)
        try container.encode(categories, forKey: .categories)
    }
}
