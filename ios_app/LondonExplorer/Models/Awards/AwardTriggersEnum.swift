//
//  AwardTriggersEnum.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 29.08.2024.
//

import Foundation

enum AwardTriggers {
    case finishedRoute
    case publishedRoute
    case friendshipApproved
    case loggedIn
    case profileOpened
    
    func getAwards(user: User, routeProgress: RouteProgress? = nil, maxLikes: Int = 0, routeNumber: Int = 0) -> [User.UserAward] {
        var awards: [User.UserAward] = []
        
        for award in AwardTypes.allCases.filter({ $0.trigger.contains(self) }) {
            print("Check award \(award.rawValue)")
            let userLevel = award.getUserLevel(user: user)
            print("Current user level \(userLevel)")
            let userPoints = award.getNewPoints(user: user, routeProgress: routeProgress, maxLikes: maxLikes, routeNumber: routeNumber)
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
