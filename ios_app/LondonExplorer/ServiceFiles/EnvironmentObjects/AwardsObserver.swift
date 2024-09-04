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
    
    private var usersService: UsersServiceProtocol = UsersService()
    private var routesService: RoutesServiceProtocol = RoutesService()
    
    @MainActor
    func checkAward(for trigger: AwardTriggers, user: User, routeProgress: RouteProgress? = nil) {
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
                try await usersService.saveUserAward(userId: user.id, awards: self.newAwards)
                withAnimation {
                    self.newAwards = []
                }
            } catch {
                print("Error saving awards")
            }
        }
        self.isSaving = false
    }
    
    func getAwardPoints(user: User, award: AwardTypes) -> Double {
        return award.getPoints(user: user, maxLikes: self.maxLikes, routeNumber: self.routesNumber)
    }
    
    @MainActor
    func getRoutesAwards(user: User) async {
        do {
            self.routesNumber = try await routesService.getRoutesNumber(userId: user.id)
            self.maxLikes = try await routesService.getMostLikes(userId: user.id)
        } catch {
            print("Unable to get routes number")
        }
    }
    
    @MainActor
    func signOut() {
        self.newAwards = []
        self.maxLikes = 0
        self.routesNumber = 0
    }
    
    func setMaxLikes(likes: Int?) {
        if let likes = likes {
            self.maxLikes = likes
        }
    }
}
