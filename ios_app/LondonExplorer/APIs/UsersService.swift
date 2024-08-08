//
//  UsersService.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 24.07.2024.
//

import Foundation

protocol UsersServiceProtocol {
    func fetchUser(userId: String) async throws -> User
    func createUser(newUser: User) async throws
    func saveFinishedRoute(userId: String, route: RouteProgress) async throws
    func removeFinishedRoutes(userId: String)
//    func saveFavRoute(userId: String, routeId: String) async throws -> Bool
//    func deleteFavRoute(userId: String, routeId: String) async throws -> Bool
}

class UsersService: UsersServiceProtocol {
    private let baseURL = URL(string: "https://c490973c-0f21-4e71-866e-f8e4c353507b-00-3j1hu3pc5bvs1.kirk.replit.dev/api/users")!
    
    @UserStorage(key: "LONDON_EXPLORER_USERS") var users: [User]
    
    enum ServiceError: Error {
        case noData
        case invalidResponse
        case serverError(Int)
    }
    
    func fetchUser(userId: String) async throws -> User {
        if var user = self.users.first(where: {
            $0.id == userId
        }) {
            return user
        } else {
            throw ServiceError.serverError(404)
        }
    }
    
    func createUser(newUser: User) async throws {
        if self.users.contains(where: { $0.id == newUser.id }) {
            throw ServiceError.serverError(409) // User already exists
        }

        self.users.append(newUser)

        if !self.users.contains(where: { $0.id == newUser.id }) {
            throw ServiceError.serverError(500) // User was not added
        }
    }
    
    func saveFinishedRoute(userId: String, route: RouteProgress) async throws {
        guard let endDate = route.endTime else {
            throw ServiceError.serverError(400)
        }
        
        guard var userProfile = users.first(where: { $0.id == userId }) else {
            throw ServiceError.serverError(404)
        }
        
        // Save finished route to users profile
//        if let savedRouteIndex = userProfile.finishedRoutes.firstIndex(where: { $0.routeId == route.route.id }) {
//            userProfile.finishedRoutes[savedRouteIndex] = User.FinishedRoute(routeId: route.route.id, finishedDate: endDate, collectables: route.collectables)
//        } else {
        userProfile.finishedRoutes.append(User.FinishedRoute(routeId: route.route.id, finishedDate: endDate, collectables: route.collectables))
        userProfile.finishedRoutes.sort { $0.finishedDate > $1.finishedDate }
//        }
        
        // Save updated users profile
        if let index = users.firstIndex(where: { $0.id == userProfile.id }) {
            users[index] = userProfile
        } else {
            throw ServiceError.serverError(500)
        }
    }
    
    func removeFinishedRoutes(userId: String) {
        if let index = users.firstIndex(where: { $0.id == userId }) {
            var user = users[index]
            user.finishedRoutes.removeAll()
            users[index] = user
        }
    }
}
