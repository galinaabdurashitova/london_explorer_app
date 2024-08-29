//
//  UserWrapper.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 12.08.2024.
//

import Foundation

struct UserWrapper: Codable {
    var userId: String
    var email: String?
    var name: String
    var userName: String
    var description: String? = nil
    var imageName: String? = nil
    var awards: [UserAward]? = []
    var collectables: [UserCollectable]? = []
    var friends: [String]? = []
    var finishedRoutes: [FinishedRoute]? = []
    
    struct UserAward: Codable {
        var userAwardId: String = UUID().uuidString
        var award: String
        var awardLevel: Int
        var awardDate: String
        
        init(userAwardId: String, award: String, awardLevel: Int, awardDate: String) {
            self.userAwardId = userAwardId
            self.award = award
            self.awardLevel = awardLevel
            self.awardDate = awardDate
        }
        
        init(from model: User.UserAward) {
            self.userAwardId = model.id
            self.award = model.type.rawValue
            self.awardLevel = model.level
            self.awardDate = DateConverter(format: "yyyy-MM-dd'T'HH:mm:ss.SSSZ").toString(from: model.date)
        }
    }
    
    struct UserCollectable: Codable {
        var userCollectableId: String = UUID().uuidString
        var collectable: String
        var finishedRouteId: String
    }
    
    struct FinishedRoute: Codable {
        var finishedRouteId: String = UUID().uuidString
        var routeId: String
        var spentMinutes: Double
        var finishedDate: String
        var collectables: Int
    }
    
    init(userId: String, email: String? = nil, name: String, userName: String, description: String? = nil, imageName: String? = nil, awards: [UserAward]? = nil, collectables: [UserCollectable]? = nil, friends: [String]? = nil, finishedRoutes: [FinishedRoute]? = nil) {
        self.userId = userId
        self.email = email
        self.name = name
        self.userName = userName
        self.description = description
        self.imageName = imageName
        self.awards = awards
        self.collectables = collectables
        self.friends = friends
        self.finishedRoutes = finishedRoutes
    }
    
    init(from model: User) {
        self.userId = model.id
        self.email = model.email
        self.name = model.name
        self.userName = model.userName
        self.imageName = model.imageName
    }
}
