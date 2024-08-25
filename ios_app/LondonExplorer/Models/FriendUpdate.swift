//
//  FriendUpdate.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 30.05.2024.
//

import Foundation
import SwiftUI

struct FriendUpdate: Identifiable {
    var id = UUID()
    var friend: User
    var description: String
    var date: Date
    var update: UpdateType
    var routeName: String? = nil
    
    enum UpdateType: String {
        case award = "Award"
        case collectable = "Collectable"
        case friend = "Friend"
        case finishedRoute = "FinishedRoute"
    }
    
    public func getIcon() -> Image {
        switch(self.update) {
        case .award:
            return Image("Medal3DIcon")
        case .collectable:
            return Image("Treasures3DIcon")
        case .friend:
            return Image("People3DIcon")
        case .finishedRoute:
            return Image("RouteDone3DIcon")
        }
    }
    
    var formattedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm, dd/MM/yyyy"
        return dateFormatter.string(from: date)
    }
    
    init(id: UUID = UUID(), friend: User, description: String, date: Date, update: UpdateType, routeName: String? = nil) {
        self.id = id
        self.friend = friend
        self.description = description
        self.date = date
        self.update = update
        self.routeName = routeName
    }
    
    init(from dto: FriendUpdateWrapper) throws {
        guard let updateType = FriendUpdate.UpdateType(rawValue: dto.updateType) else {
            throw DecodingError.dataCorrupted(
                    DecodingError.Context(
                        codingPath: [],
                        debugDescription: "Cannot convert update type"
                    )
                )
        }
        
        guard let date = DateConverter(format: "yyyy-MM-dd'T'HH:mm:ss.SSSZ").toDate(from: dto.updateDate) else {
            throw DecodingError.dataCorrupted(
                    DecodingError.Context(
                        codingPath: [],
                        debugDescription: "Cannot convert date"
                    )
                )
        }
        
        self.friend = User(
            userId: dto.userId,
            name: dto.name,
            userName: dto.userName
        )
        
        self.description = dto.description
        self.date = date
        self.update = updateType
    }
}

