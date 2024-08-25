//
//  ProfileViewModel.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 20.06.2024.
//

import Foundation
import SwiftUI

class ProfileViewModel: ObservableObject {
    // Routes
    @Published var routes: [Route] = []
    @Published var loadUnpublished: Bool
    @Published var routesLoading: Bool = false
    @Published var routesLoadingError: Bool = false
    
    // User
    @Published var user: User
    @Published var userLoading: Bool = false
    @Published var userLoadingError: Bool = false
    
    // Friends
    @Published var isUserRequestProcessing: Bool = false
    @Published var isFriendRequestSent: Bool = false
    
    // General
    @Published var error: String = ""
    @Published var showError: Bool = false
    
    private var userService: UsersServiceProtocol = UsersService()
    private var routesService: RoutesServiceProtocol = RoutesService()
    private var routesManager: RoutesStorageManager = RoutesStorageManager()
    
    init(user: User, loadUnpublished: Bool = false) {
        self.user = user
        self.loadUnpublished = loadUnpublished
    }
    
    @MainActor
    func loadData(isCurrentUser: Bool = false) async {
        self.userLoading = true
        self.routesLoading = true
        
        await self.fetchUser()
        self.userLoading = false
        
        await self.loadUserRoutes(isCurrentUser: isCurrentUser)
        self.routesLoading = false
        
        await self.getFinishedRoutes(isCurrentUser: isCurrentUser)
    }
    
    @MainActor
    func fetchUser() async {
        self.userLoadingError = false
        do {
            self.user = try await self.userService.fetchUser(userId: self.user.id)
        } catch {
            print("Error fetching user: \(error.localizedDescription)")
            self.userLoadingError = true
        }
    }
    
    @MainActor
    func getFinishedRoutes(isCurrentUser: Bool = false) async {
        for routeIndex in user.finishedRoutes.indices {
            do {
                if user.finishedRoutes[routeIndex].route == nil {
                    if isCurrentUser, let route = routesManager.getRouteById(routeId: user.finishedRoutes[routeIndex].routeId) {
                        self.user.finishedRoutes[routeIndex].route = route
                    } else {
                        let route = try await routesService.fetchRoute(routeId: user.finishedRoutes[routeIndex].routeId)
                        self.user.finishedRoutes[routeIndex].route = route
                    }
                }
            } catch {
                print("Error fetching route \(user.finishedRoutes[routeIndex].id)")
            }
        }
    }
    
    @MainActor
    func loadUserRoutes(isCurrentUser: Bool = false) async {
        self.routesLoadingError = false
        var userRoutes: [Route] = []
        if isCurrentUser {
            userRoutes.append(contentsOf: loadUserLocalRoutes())
        }
        
        do {
            userRoutes.append(contentsOf: try await loadUserPublishedRoutes())
        } catch {
            print("Unable to get user routes from API: \(error.localizedDescription)")
            if userRoutes.count == 0 {
                self.routesLoadingError = true
            }
        }
        
        self.routes = userRoutes.sorted(by: { $0.dateCreated > $1.dateCreated })
    }
    
    private func loadUserPublishedRoutes() async throws -> [Route] {
        return try await routesService.fetchUserRoutes(userId: user.id)
    }
    
    private func loadUserLocalRoutes() -> [Route] {
        return routesManager.getUserRoute(userId: user.id)
    }
    
    @MainActor
    func addFriend(userFromId: String) async {
        self.isUserRequestProcessing = true
        do {
            try await self.userService.createFriendRequest(userFromId: userFromId, userToId: self.user.id)
            await self.fetchUser()
            if !self.user.friends.contains(userFromId) {
                self.getUserFriendRequests(currentUserId: userFromId)
            }
        } catch {
            print("Unable to add friend: \(error.localizedDescription)")
            self.error = "Unable to add friend"
            self.showError = true
        }
        self.isUserRequestProcessing = false
    }
    
    @MainActor
    func getUserFriendRequests(currentUserId: String) {
        Task {
            self.isUserRequestProcessing = true
            do {
                let users = try await self.userService.fetchFriendRequests(userId: self.user.id)
                if users.compactMap({ $0.id }).contains(currentUserId) {
                    self.isFriendRequestSent = true
                }
            } catch {
                print("Unable to get friend requests: \(error.localizedDescription)")
            }
            self.isUserRequestProcessing = false
        }
    }
}
