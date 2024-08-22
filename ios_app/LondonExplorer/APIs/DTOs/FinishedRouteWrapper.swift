//
//  FinishedRouteWrapper.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 12.08.2024.
//

import Foundation

struct FinishedRouteWrapper: Codable {
    var finishedRouteId: String = UUID().uuidString
    var routeId: String
    var spentMinutes: Double
    var finishedDate: String
    var userCollectables: [UserCollectable]
    
    struct UserCollectable: Codable {
        var userCollectableId: String
        var collectable: String
    }
}
