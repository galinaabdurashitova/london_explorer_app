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
    var images: [Image] {
        get {
            if let imagesData = imagesData {
                imagesData.compactMap { data in
                    if let uiImage = UIImage.decode(data: data) {
                        return Image(uiImage: uiImage)
                    }
                    return nil
                }
            }
            return Array(repeating: Image(systemName: "photo"), count: images.count-1)
        }
        set {
            imagesData = newValue.compactMap { image in
                if let uiImage = image.asUIImage() {
                    return uiImage.encode()
                }
                return nil
            }
        }
    }
    var categories: [Category]
    
    private var imagesData: [Data]?
    
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
    
    init(id: UUID = UUID(), name: String, shortDescription: String, fullDescription: String, address: String, coordinates: CLLocationCoordinate2D, images: [Image], categories: [Category], imagesData: [Data]? = nil) {
        self.id = id
        self.name = name
        self.shortDescription = shortDescription
        self.fullDescription = fullDescription
        self.address = address
        self.coordinates = coordinates
        self.categories = categories
        self.imagesData = imagesData
        self.images = images
    }
}
