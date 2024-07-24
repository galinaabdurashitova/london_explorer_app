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
            $0.userId == userId
        }) {
            return user
        } else {
            throw ServiceError.serverError(404)
        }
    }
    
    func createUser(newUser: User) async throws {
        self.users.append(newUser)
    }
    
    func saveFinishedRoute(userId: String, route: RouteProgress) async throws {
        if var userProfile = users.first(where: {
            $0.userId == userId
        }), let endDate = route.endTime,
        let userIndex = users.firstIndex(where: {
            $0.userId == userId
        }) {
            userProfile.finishedRoutes.append(User.FinishedRoute(id: route.route.id, finishedDate: endDate, collectables: route.collectables))
            users[userIndex] = userProfile
        } else {
            throw ServiceError.serverError(400)
        }
    }
}
