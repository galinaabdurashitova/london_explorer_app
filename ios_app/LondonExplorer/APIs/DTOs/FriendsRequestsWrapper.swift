//
//  FriendsRequestsWrapper.swift.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 20.08.2024.
//

import Foundation

struct FriendsRequestsWrapper: Codable {
    var userId: String
    var email: String
    var name: String
    var userName: String
    var description: String?
}
