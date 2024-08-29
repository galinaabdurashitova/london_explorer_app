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
        
        init(userCollectableId: String, collectable: String) {
            self.userCollectableId = userCollectableId
            self.collectable = collectable
        }
        
        init(from model: Route.RouteCollectable) {
            self.userCollectableId = model.id
            self.collectable = model.type.rawValue
        }
    }
    
    init(finishedRouteId: String, routeId: String, spentMinutes: Double, finishedDate: String, userCollectables: [UserCollectable]) {
        self.finishedRouteId = finishedRouteId
        self.routeId = routeId
        self.spentMinutes = spentMinutes
        self.finishedDate = finishedDate
        self.userCollectables = userCollectables
    }
    
    init(from model: RouteProgress) throws {
        guard let endTime = model.endTime else {
            throw DecodingError.valueNotFound(
                Date.self,
                DecodingError.Context(
                    codingPath: [],
                    debugDescription: "End Time cannot be nil"
                )
            )
        }

        var newCollectables: [FinishedRouteWrapper.UserCollectable] = []
        for collectable in model.collectables {
            newCollectables.append(FinishedRouteWrapper.UserCollectable(from: collectable))
        }

        self.routeId = model.route.id
        self.spentMinutes = model.totalElapsedMinutes()
        self.finishedDate = DateConverter(format: "yyyy-MM-dd'T'HH:mm:ss.SSSZ").toString(from: endTime)
        self.userCollectables = newCollectables
    }

}
