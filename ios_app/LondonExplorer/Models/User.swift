//
//  User.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 31.05.2024.
//

import Foundation
import SwiftUI

struct User: Codable {
    var userId: String
//    var email: String
    var name: String
    var userName: String
    var userDescription: String?
    var image: UIImage
    var routesCreated: Int = 0
    var awards: Int = 0
    var collectables: Int = 0
    var friends: [User] = []
    var finishedRoutes: [Route] = []
    
    enum CodingKeys: String, CodingKey {
        case userId
//        case email
        case name
        case userName
        case userDescription
        case image
        case routesCreated
        case awards
        case collectables
        case friends
        case finishedRoutes
    }
    
    init(userId: String/*, email: String*/, name: String, userName: String, userDescription: String? = nil, image: UIImage = UIImage(imageLiteralResourceName: "User3DIcon"), routesCreated: Int = 0, awards: Int = 0, collectables: Int = 0, friends: [User] = [], finishedRoutes: [Route] = []) {
        self.userId = userId
//        self.email = email
        self.name = name
        self.userName = userName
        self.userDescription = userDescription
        self.image = image
        self.routesCreated = routesCreated
        self.awards = awards
        self.collectables = collectables
        self.friends = friends
        self.finishedRoutes = finishedRoutes
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.userId = try container.decode(String.self, forKey: .userId)
//        self.email = try container.decode(String.self, forKey: .email)
        self.name = try container.decode(String.self, forKey: .name)
        self.userName = try container.decode(String.self, forKey: .userName)
        self.userDescription = try container.decode(String?.self, forKey: .userDescription)
        self.image = UIImage(data: try container.decode(Data.self, forKey: .image)) ?? UIImage(imageLiteralResourceName: "default")
        self.routesCreated = try container.decode(Int.self, forKey: .routesCreated)
        self.awards = try container.decode(Int.self, forKey: .awards)
        self.collectables = try container.decode(Int.self, forKey: .collectables)
        self.friends = try container.decode([User].self, forKey: .friends)
        self.finishedRoutes = try container.decode([Route].self, forKey: .finishedRoutes)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(userId, forKey: .userId)
//        try container.encode(email, forKey: .email)
        try container.encode(name, forKey: .name)
        try container.encode(userName, forKey: .userName)
        try container.encode(userDescription, forKey: .userDescription)
        try container.encode(image.jpegData(compressionQuality: 1.0), forKey: .image)
        try container.encode(routesCreated, forKey: .routesCreated)
        try container.encode(awards, forKey: .awards)
        try container.encode(collectables, forKey: .collectables)
        try container.encode(friends, forKey: .friends)
        try container.encode(finishedRoutes, forKey: .finishedRoutes)
    }
}
