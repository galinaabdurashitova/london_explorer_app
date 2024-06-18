//
//  Route.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 30.05.2024.
//

import Foundation
import SwiftUI
import MapKit

struct Route: Identifiable, Codable {
    var id = UUID()
    var name: String
    var description: String
    var image: Image {
        get {
            if let data = imageData, let uiImage = UIImage.decode(data: data) {
                return Image(uiImage: uiImage)
            }
            return Image(systemName: "photo")
        }
        set {
            if let uiImage = newValue.asUIImage() {
                imageData = uiImage.encode()
            }
        }
    }
    var saves: Int = 0
    var collectables: Int
    var downloadDate: Date?
    var stops: [RouteStop] = [] {
        didSet {
            for i in 0..<(stops.count - 1) {
                if pathes.count < i {
                    pathes.append(nil)
                }
            }
        }
    }
    var pathes: [CodableMKRoute?]
    
    private var imageData: Data?
    
    struct RouteStop: Identifiable, Equatable, Codable {
        var id = UUID()
        var stepNo: Int
        var attraction: Attraction
        
        static func == (lhs: Route.RouteStop, rhs: Route.RouteStop) -> Bool {
            lhs.id == rhs.id
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case saves
        case collectables
        case downloadDate
        case stops
        case pathes
        case imageData
    }
    
    init(id: UUID = UUID(), name: String, description: String, image: Image, saves: Int = 0, collectables: Int, downloadDate: Date? = nil, stops: [RouteStop], pathes: [MKRoute?], imageData: Data? = nil) {
        self.id = id
        self.name = name
        self.description = description
        self.saves = saves
        self.collectables = collectables
        self.downloadDate = downloadDate
        self.stops = stops
        self.pathes = pathes.compactMap { $0 != nil ? CodableMKRoute(from: $0!) : nil }
        self.imageData = imageData
        self.image = image
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(UUID.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.description = try container.decode(String.self, forKey: .description)
        self.saves = try container.decode(Int.self, forKey: .saves)
        self.collectables = try container.decode(Int.self, forKey: .collectables)
        self.downloadDate = try container.decode(Date?.self, forKey: .downloadDate)
        self.stops = try container.decode([RouteStop].self, forKey: .stops)
        self.pathes = try container.decode([CodableMKRoute?].self, forKey: .pathes)
        self.imageData = try container.decode(Data?.self, forKey: .imageData)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(description, forKey: .description)
        try container.encode(saves, forKey: .saves)
        try container.encode(collectables, forKey: .collectables)
        try container.encode(downloadDate, forKey: .downloadDate)
        try container.encode(stops, forKey: .stops)
        try container.encode(pathes, forKey: .pathes)
        try container.encode(imageData, forKey: .imageData)
    }
}
