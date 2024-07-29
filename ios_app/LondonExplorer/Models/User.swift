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
//    var email: String
    var name: String
    var userName: String
    var userDescription: String?
    var image: UIImage
    var awards: Int = 0
    var collectables: Int = 0
    var friends: [String] = []
    var finishedRoutes: [FinishedRoute] = []
    var favRoutes: [String] = []
    
    struct FinishedRoute: Codable, Hashable, Equatable {
        var id: String
        var route: Route?
        var finishedDate: Date
        var collectables: Int
    }
    
    enum CodingKeys: String, CodingKey {
        case userId
//        case email
        case name
        case userName
        case userDescription
        case image
        case awards
        case collectables
        case friends
        case finishedRoutes
        case favRoutes
    }
    
    init(userId: String/*, email: String*/, name: String, userName: String, userDescription: String? = nil, image: UIImage = UIImage(imageLiteralResourceName: "User3DIcon"), awards: Int = 0, collectables: Int = 0, friends: [String] = [], finishedRoutes: [FinishedRoute] = [], favRoutes: [String] = []) {
        self.id = userId
//        self.email = email
        self.name = name
        self.userName = userName
        self.userDescription = userDescription
        self.image = image
        self.awards = awards
        self.collectables = collectables
        self.friends = friends
        self.finishedRoutes = finishedRoutes
        self.favRoutes = favRoutes
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(String.self, forKey: .userId)
//        self.email = try container.decode(String.self, forKey: .email)
        self.name = try container.decode(String.self, forKey: .name)
        self.userName = try container.decode(String.self, forKey: .userName)
        self.userDescription = try container.decode(String?.self, forKey: .userDescription)
        self.image = UIImage(data: try container.decode(Data.self, forKey: .image)) ?? UIImage(imageLiteralResourceName: "default")
        self.awards = try container.decode(Int.self, forKey: .awards)
        self.collectables = try container.decode(Int.self, forKey: .collectables)
        self.friends = try container.decode([String].self, forKey: .friends)
        self.finishedRoutes = try container.decode([FinishedRoute].self, forKey: .finishedRoutes)
        self.favRoutes = try container.decode([String].self, forKey: .favRoutes)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .userId)
//        try container.encode(email, forKey: .email)
        try container.encode(name, forKey: .name)
        try container.encode(userName, forKey: .userName)
        try container.encode(userDescription, forKey: .userDescription)
        try container.encode(image.jpegData(compressionQuality: 1.0), forKey: .image)
        try container.encode(awards, forKey: .awards)
        try container.encode(collectables, forKey: .collectables)
        try container.encode(friends, forKey: .friends)
        try container.encode(finishedRoutes, forKey: .finishedRoutes)
        try container.encode(favRoutes, forKey: .favRoutes)
    }
}
