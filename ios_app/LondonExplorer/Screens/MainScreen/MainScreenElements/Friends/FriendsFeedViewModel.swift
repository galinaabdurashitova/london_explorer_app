//
//  FriendsFeedViewModel.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 21.08.2024.
//

import Foundation
import SwiftUI

class FriendsFeedViewModel: ObservableObject {
    @Published var updates: [FriendUpdate] = []
    @Published var friendsRequests: [User] = []
    @Published var isLoading: Bool = false
    @Published var error: Bool = false
    
    private var usersService: UsersServiceProtocol = UsersService()
    private var routesService: RoutesServiceProtocol = RoutesService()
    
    @MainActor
    func reloadFeed(userId: String) {
        self.isLoading = true
        self.error = false
        
        Task {
            do {
                try await self.getUpdates(userId: userId)
                await self.getFriendRequests(userId: userId)
            } catch {
                self.error = true
            }
            
            self.isLoading = false
        }
    }
    
    @MainActor
    func getUpdates(userId: String) async throws {
        do {
            self.updates = try await self.usersService.fetchFriendsUpdates(userId: userId, limit: 30)
            for updateIndex in self.updates.indices {
                if self.updates[updateIndex].update == .finishedRoute {
                    do {
                        let routeName = try await self.routesService.getRouteName(routeId: self.updates[updateIndex].description)
                        self.updates[updateIndex].routeName = routeName
                    } catch {
                        print("Could not fetch a route: \(self.updates[updateIndex].description)")
                    }
                }
            }
        } catch {
            print("Unable to get friends feed: \(error.localizedDescription)")
            throw error
        }
    }
    
    @MainActor
    func getFriendRequests(userId: String) async {
        do {
            self.friendsRequests = try await self.usersService.fetchFriendRequests(userId: userId)
        } catch {
            print("Unable to get friend requests: \(error.localizedDescription)")
        }
    }

    func acceptRequest(currentUserId: String, userFromId: String) async {
        do {
            try await self.usersService.createFriendRequest(userFromId: currentUserId, userToId: userFromId)
            await self.reloadFeed(userId: currentUserId)
        } catch {
            print("Unable to add friend: \(error.localizedDescription)")
        }
    }
    
    func declineRequest(currentUserId: String, userFromId: String) {
        Task {
            do {
                try await self.usersService.declineFriendRequest(userFromId: currentUserId, userToId: userFromId)
                await self.reloadFeed(userId: currentUserId)
            } catch {
                print("Unable to add friend: \(error.localizedDescription)")
            }
        }
    }
}
