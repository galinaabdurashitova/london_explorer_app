//
//  User.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 31.05.2024.
//

import Foundation
import SwiftUI

struct User: Codable, Identifiable, Hashable, Equatable {
    static func == (lhs: User, rhs: User) -> Bool {
        lhs.id == rhs.id
    }
    
    var id: String
    var email: String?
    var name: String
    var userName: String
    var description: String?
    var image: UIImage?
    var awards: [UserAward]
    var collectables: [UserCollectable]
    var friends: [String]
    var finishedRoutes: [FinishedRoute]
    
    struct UserAward: Codable, Hashable, Equatable {
        var id: String = UUID().uuidString
        var type: AwardTypes
        var level: Int
        var date: Date
    }
    
    struct UserCollectable: Codable, Hashable, Equatable {
        var id: String = UUID().uuidString
        var type: Collectable
        var finishedRouteId: String
    }
    
    struct FinishedRoute: Codable, Hashable, Equatable {
        var id: String = UUID().uuidString
        var routeId: String
        var route: Route?
        var spentMinutes: Double
        var finishedDate: Date
        var collectables: Int
    }
    
    enum CodingKeys: String, CodingKey {
        case userId
        case email
        case name
        case userName
        case userDescription
//        case image
        case awards
        case collectables
        case friends
        case finishedRoutes
    }
    
    init(userId: String, email: String? = nil, name: String, userName: String, userDescription: String? = nil, image: UIImage? = nil, awards: [UserAward] = [], collectables: [UserCollectable] = [], friends: [String] = [], finishedRoutes: [FinishedRoute] = []) {
        self.id = userId
        self.email = email
        self.name = name
        self.userName = userName
        self.description = userDescription
        self.image = image
        self.awards = awards
        self.collectables = collectables
        self.friends = friends
        self.finishedRoutes = finishedRoutes
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(String.self, forKey: .userId)
        self.email = try container.decode(String?.self, forKey: .email)
        self.name = try container.decode(String.self, forKey: .name)
        self.userName = try container.decode(String.self, forKey: .userName)
        self.description = try container.decode(String?.self, forKey: .userDescription)
//        self.image = UIImage(data: try container.decode(Data.self, forKey: .image)) ?? nil
        self.awards = try container.decode([UserAward].self, forKey: .awards)
        self.collectables = try container.decode([UserCollectable].self, forKey: .collectables)
        self.friends = try container.decode([String].self, forKey: .friends)
        self.finishedRoutes = try container.decode([FinishedRoute].self, forKey: .finishedRoutes)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .userId)
        try container.encode(email, forKey: .email)
        try container.encode(name, forKey: .name)
        try container.encode(userName, forKey: .userName)
        try container.encode(description, forKey: .userDescription)
//        if let image = image {
//            try container.encode(image.jpegData(compressionQuality: 1.0), forKey: .image)
//        }
        try container.encode(awards, forKey: .awards)
        try container.encode(collectables, forKey: .collectables)
        try container.encode(friends, forKey: .friends)
        try container.encode(finishedRoutes, forKey: .finishedRoutes)
    }
}
