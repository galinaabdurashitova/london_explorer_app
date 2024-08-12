//
//  Award.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 12.08.2024.
//

import Foundation

enum AwardTypes: String, Codable {
    case routesFinished = "FinishedRoutes"
    case attractionsVisited = "VisitedAttractions"
    case routesPublished = "PublishedRoutes"
    case friends = "Friends"
    case minutes = "RouteMinutes"
    case kilometers = "RouteKilometers"
    case likedRoute = "RouteGotLikes"
    case collectables = "Collectables"
    
    enum AwardTriggers {
        case finishedRoute
        case publishedRoute
        case friendshipApproved
        case loggedIn
        case profileOpened
    }
    
    var trigger: [AwardTriggers] {
        switch self {
        case .routesFinished:
            return [.finishedRoute]
        case .attractionsVisited:
            return [.finishedRoute]
        case .routesPublished:
            return [.publishedRoute]
        case .friends:
            return [.friendshipApproved, .loggedIn, .profileOpened]
        case .minutes:
            return [.finishedRoute]
        case .kilometers:
            return [.finishedRoute]
        case .likedRoute:
            return [.loggedIn, .profileOpened]
        case .collectables:
            return [.finishedRoute]
        }
    }
    
    var number: Double {
        switch self {
        case .routesFinished:
            return 5
        case .attractionsVisited:
            return 10
        case .routesPublished:
            return 10
        case .friends:
            return 5
        case .minutes:
            return 120
        case .kilometers:
            return 10
        case .likedRoute:
            return 25
        case .collectables:
            return 5
        }
    }
    
    func checkAward(user: User) -> Bool {
        let userAwards = user.awards.filter({ $0.type == self })
        let nextLevel = userAwards.count + 1
        
        if nextLevel < 4 {
            let levelNumber = self.number * pow(2, Double(nextLevel))
            
            switch self {
            case .routesFinished:
                return Double(user.finishedRoutes.count) >= levelNumber
            case .attractionsVisited:
                return Double(user.finishedRoutes.compactMap { $0.route?.stops.count }.reduce(0, +)) >= levelNumber
            case .minutes:
                let totalRouteTime = user.finishedRoutes.compactMap { $0.route?.routeTime }.reduce(0, +)
                return Double(totalRouteTime / 60) >= levelNumber
            case .kilometers:
                let totalDistance = user.finishedRoutes.compactMap { $0.route?.pathes.compactMap { $0?.expectedTravelTime }.reduce(0, +) }.reduce(0, +)
                return Double(totalDistance) / 1000 >= levelNumber
            case .collectables:
                return Double(user.collectables.count) >= levelNumber
            case .friends:
                return Double(user.friends.count) >= levelNumber
            default:
                return false
            }
        } else {
            return false
        }
    }
}
