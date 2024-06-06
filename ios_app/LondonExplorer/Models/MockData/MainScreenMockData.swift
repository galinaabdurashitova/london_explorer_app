//
//  MainScreenMockData.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 30.05.2024.
//

import Foundation
import SwiftUI

class MockData {
    public static var MainScreen: [Route] = [
        Route(
            name: "Best London Route",
            description: "Visit all the main sights and see Big Ben following this fantastic route",
            image: Image("BigBen"),
            saves: 212,
            collectables: 5,
            stops: 6
        ),
        Route(
            name: "London Secrets",
            description: "Another description but shorter",
            image: Image("Museum"),
            saves: 52,
            collectables: 7,
            stops: 4
        ),
        Route(
            name: "Some Route Some Route Some Route",
            description: "Visit all the main sights and see Big Ben following this fantastic route",
            image: Image("LondonStreet"),
            saves: 103,
            collectables: 5,
            stops: 6
        ),
        Route(
            name: "Best London Route",
            description: "Visit all the main sights and see Big Ben following this fantastic route",
            image: Image("BigBen"),
            saves: 212,
            collectables: 5,
            stops: 6,
            downloadDate: Date()
        ),
        Route(
            name: "London Secrets",
            description: "Another description but shorter",
            image: Image("Museum"),
            saves: 52,
            collectables: 5,
            stops: 6
        )//,
//        Route(
//            name: "Some Route",
//            description: "Visit all the main sights and see Big Ben following this fantastic route",
//            image: Image("LondonStreet"),
//            saves: 103
//        )
    ]
    
    public static var FriendsFeed: [FriendUpdate] = [
        FriendUpdate(
            friend: Users[0],
            caption: "Anna completed a route",
            subCaption: "Best London route",
            date: Date(),
            update: FriendUpdate.UpdateType.routeCompleted
        ),
        FriendUpdate(
            friend: Users[1],
            caption: "Mary achieved a medal",
            subCaption: "for 100 collectables",
            date: Date(),
            update: FriendUpdate.UpdateType.collectables100
        ),
        FriendUpdate(
            friend: Users[0],
            caption: "Anna completed a route",
            subCaption: "Best London route",
            date: Date(),
            update: FriendUpdate.UpdateType.routeCompleted
        )
    ]
    
    public static var Users: [User] = [
        User(userId: "1", name: "Anna", image: Image("Anna")),
        User(userId: "2", name: "Mary", image: Image("Mary"))
    ]
    
    public static var RouteProgress: [RouteProgress] = [
        LondonExplorer.RouteProgress(route: MainScreen[2], collectables: 3, stops: 4),
        LondonExplorer.RouteProgress(route: MainScreen[2], collectables: 3, stops: 4, user: Users[0]),
        LondonExplorer.RouteProgress(route: MainScreen[1], collectables: 2, stops: 1, user: Users[1])
    ]
}
