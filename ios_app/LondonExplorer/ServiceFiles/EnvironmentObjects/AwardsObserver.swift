//
//  AwardsObserver.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 22.08.2024.
//

import Foundation
import SwiftUI

class AwardsObserver: ObservableObject {
    @Published var newAwards: [User.UserAward] = []
    @Published var isSaving: Bool = false
    private var routesNumber: Int = 0
    private var maxLikes: Int = 0
    
    @MainActor
    func checkAward(for trigger: AwardTypes.AwardTriggers, user: User, routeProgress: RouteProgress? = nil) {
        withAnimation {
            self.newAwards = trigger.getAwards(user: user, routeProgress: routeProgress,  maxLikes: self.maxLikes, routeNumber: self.routesNumber)
        }
        print("Awards checked")
    }
    
    @MainActor
    func saveAwards(user: User) async {
        self.isSaving = true
        if !self.newAwards.isEmpty {
            do {
                try await UsersService().saveUserAward(userId: user.id, awards: self.newAwards)
            } catch {
                print("Error saving awards")
            }
            withAnimation { newAwards = [] }
        }
        self.isSaving = false
    }
    
    func getAwardPoints(user: User, award: AwardTypes) -> Double {
//        print("Check for \(award.rawValue) with \(self.routesNumber)")
        return award.getPoints(user: user, maxLikes: self.maxLikes, routeNumber: self.routesNumber)
    }
    
    func getRoutesNumber(user: User) async {
        do {
            let routes = try await RoutesService().fetchUserRoutes(userId: user.id)
            self.routesNumber = routes.count
        } catch {
            print("Unable to get routes number")
        }
    }
    
    func setMaxLikes(likes: Int?) {
        if let likes = likes {
            self.maxLikes = likes
        }
    }
}
