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
    var caption: String
    var subCaption: String
    var date: Date
    var update: UpdateType
    
    public enum UpdateType {
        case routeCompleted
        case collectables100
    }
    
    public func getIcon() -> Image {
        switch(self.update) {
        case .collectables100:
            return Image("Medal3DIcon")
        case .routeCompleted:
            return Image("RouteDone3DIcon")
        default:
            return Image("Start3DIcon")
        }
    }
    
    var formattedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm, dd/MM/yyyy"
        return dateFormatter.string(from: date)
    }
}

