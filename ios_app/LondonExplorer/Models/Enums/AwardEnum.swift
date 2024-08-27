//
//  Award.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 12.08.2024.
//

import Foundation
import SwiftUI

enum AwardTypes: String, Codable, CaseIterable {
    case routesFinished = "Finished routes"
    case attractionsVisited = "Visited attractions"
    case routesPublished = "Published routes"
    case friends = "Number of friends"
    case minutes = "Minutes Spent on routes"
    case kilometers = "Kilometers passed total"
    case likedRoute = "Number of likes that your route got"
    case collectables = "Found collectables"
    
    enum AwardTriggers {
        case finishedRoute
        case publishedRoute
        case friendshipApproved
        case loggedIn
        case profileOpened
        
        func getAwards(user: User, routeProgress: RouteProgress? = nil, routeNumber: Int = 0) -> [User.UserAward] {
            var awards: [User.UserAward] = []
            
            for award in AwardTypes.allCases.filter({ $0.trigger.contains(self) }) {
                print("Check award \(award.rawValue)")
                let userLevel = award.getUserLevel(user: user)
                print("Current user level \(userLevel)")
                let userPoints = award.getNewPoints(user: user, routeProgress: routeProgress, routeNumber: routeNumber)
                print("New user points \(userPoints)")
                let newUserLevel = award.getLevelForPoints(points: userPoints)
                print("New user level \(newUserLevel)")
                
                if newUserLevel > userLevel {
                    awards.append(User.UserAward(type: award, level: newUserLevel, date: Date()))
                }
            }
            
            return awards
        }
    }
    
    var trigger: [AwardTriggers] {
        switch self {
        case .routesFinished:       return [.finishedRoute]
        case .attractionsVisited:   return [.finishedRoute]
        case .routesPublished:      return [.publishedRoute]                /// No
        case .friends:              return [.friendshipApproved, .loggedIn, .profileOpened]
        case .minutes:              return [.finishedRoute]
        case .kilometers:           return [.finishedRoute]
        case .likedRoute:           return [.loggedIn, .profileOpened]      /// No
        case .collectables:         return [.finishedRoute]
        }
    }
    
    var image: Image {
        switch self {
        case .routesFinished:       return Image("RouteDone3DIcon")
        case .attractionsVisited:   return Image("BigBen3DIcon")
        case .routesPublished:      return Image("Done3DIcon")
        case .friends:              return Image("People3DIcon")
        case .minutes:              return Image("Watch3DIcon")
        case .kilometers:           return Image("Path3DIcon")
        case .likedRoute:           return Image("Like3DIcon")
        case .collectables:         return Image("Treasures3DIcon")
        }
    }
    
    var firstLevelNumber: Double {
        switch self {
        case .routesFinished:       return 5
        case .attractionsVisited:   return 10
        case .routesPublished:      return 10
        case .friends:              return 5
        case .minutes:              return 120
        case .kilometers:           return 10
        case .likedRoute:           return 25
        case .collectables:         return 5
        }
    }
    
    func getPoints(user: User, routeNumber: Int = 0) -> Double {
        switch self {
        case .routesFinished:
            return Double(user.finishedRoutes.count)
        case .attractionsVisited:
            return Double(user.finishedRoutes.compactMap { $0.route?.stops.count }.reduce(0, +))
        case .routesPublished:
            return Double(routeNumber)
        case .friends:
            return Double(user.friends.count)
        case .minutes:
            return user.finishedRoutes.compactMap { $0.spentMinutes }.reduce(0, +)
        case .kilometers:
            let totalDistance = user.finishedRoutes.compactMap { $0.route?.pathes.compactMap { $0?.expectedTravelTime }.reduce(0, +) }.reduce(0, +)
            return Double(totalDistance) / 1000
        case .likedRoute:
            return 0
        case .collectables:
            return Double(user.collectables.count)
        }
    }
    
    func getNewPoints(user: User, routeProgress: RouteProgress? = nil, routeNumber: Int = 0) -> Double {
        switch self {
        case .routesFinished:
            return self.getPoints(user: user) + 1
        case .attractionsVisited:
            return self.getPoints(user: user) + Double(routeProgress == nil ? 0 : routeProgress!.route.stops.count)
        case .routesPublished:
            return Double(routeNumber)
        case .friends:
            return Double(user.friends.count)
        case .minutes:
            return self.getPoints(user: user) + (routeProgress == nil ? 0 : routeProgress!.totalElapsedMinutes())
        case .kilometers:
            let newKilometers = (routeProgress == nil ? 0 : routeProgress!.route.pathes.compactMap({ $0?.expectedTravelTime }).reduce(0, +) / 1000)
            return self.getPoints(user: user) + newKilometers
        case .likedRoute:
            return 0
        case .collectables:
            let newCollectables = (routeProgress == nil ? [] : routeProgress!.collectables.filter{ !user.collectables.compactMap{ $0.type }.contains($0.type) })
            return self.getPoints(user: user) + Double(newCollectables.count)
        }
    }
    
    func getLevelPoints(level: Int) -> Double {
        if level <= 0 {
            return 0
        } else if level > 3 {
            return self.firstLevelNumber * pow(2, Double(3 - 1))
        } else {
            return self.firstLevelNumber * pow(2, Double(level - 1))
        }
    }
    
    func getUserLevel(user: User) -> Int {
        return min(user.awards.filter({ $0.type == self }).count, 3)
    }
    
    func getCurrentLevel(user: User) -> User.UserAward? {
        return user.awards.filter({ $0.type == self }).max(by: { $0.level < $1.level })
    }
    
    func checkAward(user: User) -> Bool {
        let nextLevel = getUserLevel(user: user) + 1
        
        if nextLevel < 4 {
            return self.getPoints(user: user) >= self.getLevelPoints(level: nextLevel)
        } else {
            return false
        }
    }
    
    func getLevelForPoints(points: Double) -> Int {
        for i in 1...3 {
            if points < self.getLevelPoints(level: i) {
                return i - 1
            }
        }
        
        return 3
    }
}
