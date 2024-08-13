//
//  UserWrapper.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 12.08.2024.
//

import Foundation

struct UserWrapper: Codable {
    var userId: String
    var email: String
    var name: String
    var userName: String
    var description: String? = nil
    var awards: [UserAward] = []
    var collectables: [UserCollectable] = []
    var friends: [String] = []
    var finishedRoutes: [FinishedRoute] = []
    
    struct UserAward: Codable {
        var awardId: String = UUID().uuidString
        var award: String
        var awardLevel: Int
        var awardDate: String
    }
    
    struct UserCollectable: Codable {
        var userCollectableId: String = UUID().uuidString
        var collectable: String
        var finishedRouteId: String
    }
    
    struct FinishedRoute: Codable {
        var finishedRouteId: String = UUID().uuidString
        var routeId: String
        var finishedDate: String
        var collectables: Int
    }
}
