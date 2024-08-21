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
    
    private var usersService: UsersServiceProtocol = UsersService()
    private var routesService: RoutesServiceProtocol = RoutesService()
    
    func reloadFeed(userId: String) {
        self.isLoading = true
        self.getFriendRequests(userId: userId)
        self.getUpdates(userId: userId)
        self.isLoading = false
    }
    
    func getUpdates(userId: String) {
        DispatchQueue.main.async {
            Task {
                do {
                    self.updates = try await self.usersService.fetchFriendsUpdates(userId: userId, limit: 30)
                    for updateIndex in self.updates.indices {
                        if self.updates[updateIndex].update == .finishedRoute {
                            let route = try await self.routesService.fetchRoute(routeId: self.updates[updateIndex].description)
                            self.updates[updateIndex].routeName = route.name
                        }
                    }
                } catch {
                    print("Unable to get friends feed")
                }
            }
        }
    }
    
    func getFriendRequests(userId: String) {
        DispatchQueue.main.async {
            Task {
                do {
                    self.friendsRequests = try await self.usersService.fetchFriendRequests(userId: userId)
                } catch {
                    print("Unable to get friend requests: \(error.localizedDescription)")
                }
            }
        }
    }

    func acceptRequest(currentUserId: String, userFromId: String) {
        Task {
            do {
                try await self.usersService.createFriendRequest(userFromId: currentUserId, userToId: userFromId)
                self.reloadFeed(userId: currentUserId)
            } catch {
                print("Unable to add friend: \(error.localizedDescription)")
            }
        }
    }
    
    func declineRequest(currentUserId: String, userFromId: String) {
        Task {
            do {
                try await self.usersService.declineFriendRequest(userFromId: currentUserId, userToId: userFromId)
                self.reloadFeed(userId: currentUserId)
            } catch {
                print("Unable to add friend: \(error.localizedDescription)")
            }
        }
    }
}
