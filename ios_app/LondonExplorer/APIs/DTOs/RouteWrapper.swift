//
//  RouteWrapper.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 25.08.2024.
//

import Foundation

struct RouteWrapper: Codable {
    var routeId: String
    var dateCreated: String
    var userCreated: String
    var routeName: String
    var routeDescription: String
    var routeTime: Int
    var datePublished: String
    var saves: [String]? = nil
    var stops: [RouteStop]
    var collectables: [RouteCollectable]
    
    struct RouteStop: Codable {
        var stopId: String
        var stepNumber: Int
        var attractionId: String
        
        init(stopId: String, stepNumber: Int, attractionId: String) {
            self.stopId = stopId
            self.stepNumber = stepNumber
            self.attractionId = attractionId
        }
        
        init(from model: Route.RouteStop) {
            self.stopId = model.id
            self.stepNumber = model.stepNo
            self.attractionId = model.attraction.id
        }
    }
    
    struct RouteCollectable: Codable {
        var routeCollectableId: String
        var collectable: String
        var latitude: Double
        var longitude: Double
        
        init(routeCollectableId: String, collectable: String, latitude: Double, longitude: Double) {
            self.routeCollectableId = routeCollectableId
            self.collectable = collectable
            self.latitude = latitude
            self.longitude = longitude
        }
        
        init(from model: Route.RouteCollectable) {
            self.routeCollectableId = model.id
            self.collectable = model.type.rawValue
            self.latitude = model.location.latitude
            self.longitude = model.location.longitude
        }
    }
    
    init(routeId: String, dateCreated: String, userCreated: String, routeName: String, routeDescription: String, routeTime: Int, datePublished: String, saves: [String]? = nil, stops: [RouteStop], collectables: [RouteCollectable]) {
        self.routeId = routeId
        self.dateCreated = dateCreated
        self.userCreated = userCreated
        self.routeName = routeName
        self.routeDescription = routeDescription
        self.routeTime = routeTime
        self.datePublished = datePublished
        self.saves = saves
        self.stops = stops
        self.collectables = collectables
    }
    
    init(from model: Route) {
        self.routeId = model.id
        self.dateCreated = DateConverter(format: "yyyy-MM-dd'T'HH:mm:ss.SSSZ").toString(from: model.dateCreated)
        self.userCreated = model.userCreated
        self.routeName = model.name
        self.routeDescription = model.description
        self.routeTime = Int(model.routeTime)
        self.datePublished = DateConverter(format: "yyyy-MM-dd'T'HH:mm:ss.SSSZ").toString(from: model.datePublished ?? Date())
        self.saves = nil
        self.stops = model.stops.compactMap { RouteWrapper.RouteStop(from: $0) }
        self.collectables = model.collectables.compactMap { RouteWrapper.RouteCollectable(from: $0) }
    }
}
