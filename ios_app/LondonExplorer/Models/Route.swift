//
//  Route.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 30.05.2024.
//

import Foundation
import SwiftUI
import MapKit

struct Route: Identifiable, Codable, Hashable {
    var id: String
    var dateCreated: Date
    var userCreated: String
    var name: String
    var description: String
    var saves: [String]
    var collectables: [RouteCollectable]
    var downloadDate: Date?
    var datePublished: Date?
    var stops: [RouteStop] = []
    {
        didSet {
            for i in 0..<(stops.count - 1) {
                if pathes.count < i {
                    pathes.append(nil)
                }
            }
        }
    }
    var pathes: [CodableMKRoute?] = []
    var routeTime: Double
    
    struct RouteCollectable: Codable, Hashable {
        var id: String
        var location: CLLocationCoordinate2D
        var type: Collectable
        
        init(id: String = UUID().uuidString, location: CLLocationCoordinate2D, type: Collectable) {
            self.id = id
            self.location = location
            self.type = type
        }
        
        init(from dto: RouteWrapper.RouteCollectable) throws {
            guard let collectable = Collectable(rawValue: dto.collectable) else {
                throw DecodingError.dataCorrupted(
                        DecodingError.Context(
                            codingPath: [],
                            debugDescription: "Cannot convert collectable"
                        )
                    )
            }
            
            self.id = dto.routeCollectableId
            self.location = CLLocationCoordinate2D(latitude: dto.latitude, longitude: dto.longitude)
            self.type = collectable
        }
    }
    
    struct RouteStop: Identifiable, Equatable, Codable, Hashable {
        var id: String = UUID().uuidString
        var stepNo: Int
        var attraction: Attraction
        
        static func == (lhs: Route.RouteStop, rhs: Route.RouteStop) -> Bool {
                    lhs.id == rhs.id
                }
    }
    
    init(id: String = UUID().uuidString, dateCreated: Date, userCreated: String, name: String, description: String, saves: [String] = [], collectables: [RouteCollectable], downloadDate: Date? = nil, datePublished: Date? = nil, stops: [RouteStop], pathes: [CodableMKRoute?], calculatedRotueTime: Double? = nil) {
        self.id = id
        self.dateCreated = dateCreated
        self.userCreated = userCreated
        self.name = name
        self.description = description
        self.saves = saves
        self.collectables = collectables
        self.downloadDate = downloadDate
        self.datePublished = datePublished
        self.stops = stops
        self.pathes = pathes
        if let time = calculatedRotueTime {
            self.routeTime = time
        } else {
            self.routeTime = pathes.compactMap { $0?.expectedTravelTime }.reduce(0, +) + Double(stops.count * 15 * 60)
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case dateCreated
        case userCreated
        case name
        case description
        case image
        case imageURL
        case saves
        case collectables
        case downloadDate
        case datePublished
        case stops
        case pathes
        case routeTime
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decode(String.self, forKey: .id)
        self.dateCreated = try container.decode(Date.self, forKey: .dateCreated)
        self.userCreated = try container.decode(String.self, forKey: .userCreated)
        self.name = try container.decode(String.self, forKey: .name)
        self.description = try container.decode(String.self, forKey: .description)
        self.saves = try container.decode([String].self, forKey: .saves)
        self.collectables = try container.decode([RouteCollectable].self, forKey: .collectables)
        self.downloadDate = try container.decode(Date?.self, forKey: .downloadDate)
        self.datePublished = try container.decode(Date?.self, forKey: .datePublished)
        self.stops = try container.decode([RouteStop].self, forKey: .stops)
        self.pathes = try container.decode([CodableMKRoute?].self, forKey: .pathes)
        self.routeTime = try container.decode(Double.self, forKey: .routeTime)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(id, forKey: .id)
        try container.encode(dateCreated, forKey: .dateCreated)
        try container.encode(userCreated, forKey: .userCreated)
        try container.encode(name, forKey: .name)
        try container.encode(description, forKey: .description)
        try container.encode(saves, forKey: .saves)
        try container.encode(collectables, forKey: .collectables)
        try container.encode(downloadDate, forKey: .downloadDate)
        try container.encode(datePublished, forKey: .datePublished)
        try container.encode(stops, forKey: .stops)
        try container.encode(pathes, forKey: .pathes)
        try container.encode(routeTime, forKey: .routeTime)
    }
}
