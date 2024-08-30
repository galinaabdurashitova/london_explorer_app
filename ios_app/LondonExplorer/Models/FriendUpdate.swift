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
    var routeName: String?
    
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
}

