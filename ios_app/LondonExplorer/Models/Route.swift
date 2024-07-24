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
    var id = UUID()
    var dateCreated: Date
    var userCreated: UserCreated
    var name: String
    var description: String
    var image: UIImage
    var saves: Int = 0
    var collectables: Int
    var downloadDate: Date?
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
    
    struct UserCreated: Identifiable, Equatable, Codable, Hashable {
        var id = UUID()
        var userId: String
        var name: String?
    }
    
    struct RouteStop: Identifiable, Equatable, Codable, Hashable {
        var id = UUID()
        var stepNo: Int
        var attraction: Attraction
        
        static func == (lhs: Route.RouteStop, rhs: Route.RouteStop) -> Bool {
            lhs.id == rhs.id
        }
    }

    
    enum CodingKeys: String, CodingKey {
        case id
        case dateCreated
        case userCreated
        case name
        case description
        case image
        case saves
        case collectables
        case downloadDate
        case stops
        case pathes
    }
    
    init(id: UUID = UUID(), dateCreated: Date, userCreated: UserCreated, name: String, description: String, image: UIImage, saves: Int = 0, collectables: Int, downloadDate: Date? = nil, stops: [RouteStop], pathes: [CodableMKRoute?]
    ) {
        self.id = id
        self.dateCreated = dateCreated
        self.userCreated = userCreated
        self.name = name
        self.description = description
        self.image = image
        self.saves = saves
        self.collectables = collectables
        self.downloadDate = downloadDate
        self.stops = stops
        self.pathes = pathes//.compactMap { $0 != nil ? CodableMKRoute(from: $0!) : nil }
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(UUID.self, forKey: .id)
        self.dateCreated = try container.decode(Date.self, forKey: .dateCreated)
        self.userCreated = try container.decode(UserCreated.self, forKey: .userCreated)
        self.name = try container.decode(String.self, forKey: .name)
        self.description = try container.decode(String.self, forKey: .description)
        self.image = UIImage(data: try container.decode(Data.self, forKey: .image)) ?? UIImage(imageLiteralResourceName: "default")
        self.saves = try container.decode(Int.self, forKey: .saves)
        self.collectables = try container.decode(Int.self, forKey: .collectables)
        self.downloadDate = try container.decode(Date?.self, forKey: .downloadDate)
        self.stops = try container.decode([RouteStop].self, forKey: .stops)
        self.pathes = try container.decode([CodableMKRoute?].self, forKey: .pathes)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(dateCreated, forKey: .dateCreated)
        try container.encode(userCreated, forKey: .userCreated)
        try container.encode(name, forKey: .name)
        try container.encode(description, forKey: .description)
        try container.encode(image.jpegData(compressionQuality: 1.0), forKey: .image)
        try container.encode(saves, forKey: .saves)
        try container.encode(collectables, forKey: .collectables)
        try container.encode(downloadDate, forKey: .downloadDate)
        try container.encode(stops, forKey: .stops)
        try container.encode(pathes, forKey: .pathes)
    }
}
