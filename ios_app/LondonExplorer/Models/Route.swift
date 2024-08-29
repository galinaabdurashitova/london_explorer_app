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
}
