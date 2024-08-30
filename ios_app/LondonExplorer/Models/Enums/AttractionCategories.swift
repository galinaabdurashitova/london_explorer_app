//
//  AttractionCategories.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 29.08.2024.
//

import Foundation
import SwiftUI

enum Category: String, CaseIterable, Identifiable, Codable, Hashable {
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
        case .historical:       return Color.blueAccent
        case .museums:          return Color.redAccent
        case .entertainment:    return Color.yellowAccent
        case .parks:            return Color.greenAccent
        case .markets:          return Color.blueAccent
        case .pubs:             return Color.redAccent
        case .restaurants:      return Color.yellowAccent
        case .unique:           return Color.greenAccent
        case .hotels:           return Color.blueAccent
        case .mustsee:          return Color.redAccent
        case .cultural:         return Color.yellowAccent
        case .shopping:         return Color.greenAccent
        }
    }
}
