//
//  UsersService.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 24.07.2024.
//

import Foundation

protocol UsersServiceProtocol: Service {
    func fetchUser(userId: String) async throws -> User                             // Get user by id
    func createUser(newUser: User) async throws                                     // Create user
    func saveFinishedRoute(userId: String, route: RouteProgress) async throws       // Save finished route
    func saveUserAward(userId: String, awards: [User.UserAward]) async throws       // Save user award
    func updateUserInfo(userId: String, newName: String?, newUserName: String?,
                        newDescription: String?, newImageName: String?) async throws // Update user
    func fetchAllUsers() async throws -> [User]                                     // Get all users
    func fetchUsers(userIds: [String]?) async throws -> [User]                      // Get users by IDs
    func createFriendRequest(userFromId: String, userToId: String) async throws     // Send/confirm friend request
    func declineFriendRequest(userFromId: String, userToId: String) async throws    // Decline friend request
    func fetchFriendRequests(userId: String) async throws -> [User]                 // Get friendship requests
    func fetchFriendsUpdates(userId: String, limit: Int) async throws -> [FriendUpdate] // Get friends updates
}

class UsersService: Service, UsersServiceProtocol {
    private var serviceURL: URL {
        if Server.localServer {
            URL(string: "http://localhost:8081/api/users")!
        } else {
            URL(string: "https://users-api-gmabdurashitova.replit.app/api/users")!
        }
    }
    
    private let serviceName = "Users service"
    
    private let userMapper: UserMapper = UserMapper()
    private let friendUpdateMapper: FriendUpdateMapper = FriendUpdateMapper()

    
    func fetchUser(userId: String) async throws -> User {
        let methodName = "fetchUser"
        let url = serviceURL.appendingPathComponent("\(userId)")

        let data = try await self.makeRequest(method: .get, url: url, serviceName: serviceName, methodName: methodName)
        let user = try decodeResponse(from: data, as: UserWrapper.self, serviceName: serviceName, methodName: methodName)
        let responseUsers = await userMapper.mapToUser(from: user)
        return responseUsers
    }
    
    
    func createUser(newUser: User) async throws {
        let methodName = "createUser"
        
        let _ = try await self.makeRequest(method: .post, url: serviceURL, body: UserWrapper(from: newUser),
                                               serviceName: serviceName, methodName: methodName)
    }
    
    
    func saveFinishedRoute(userId: String, route: RouteProgress) async throws {
        guard route.endTime != nil else { throw ServiceError.serverError(400) }
        let methodName = "saveFinishedRoute"
        let url = serviceURL.appendingPathComponent("\(userId)/finishedRoutes")
        
        let _ = try await self.makeRequest(method: .post, url: url, body: FinishedRouteWrapper(from: route),
                                               serviceName: serviceName, methodName: methodName)
    }
    
    
    func saveUserAward(userId: String, awards: [User.UserAward]) async throws {
        let methodName = "saveUserAward"
        let url = serviceURL.appendingPathComponent("\(userId)/awards")
        
        let newAwards = awards.compactMap { UserWrapper.UserAward(from: $0) }
        let _ = try await self.makeRequest(method: .post, url: url, body: newAwards,
                                           serviceName: serviceName, methodName: methodName)
    }
    
    
    func updateUserInfo(userId: String, newName: String? = nil, newUserName: String? = nil, newDescription: String? = nil, newImageName: String? = nil) async throws {
        let methodName = "updateUserInfo"
        let url = serviceURL.appendingPathComponent("\(userId)")
        
        let newUserInfo = UpdateUserRequest(name: newName, userName: newUserName, description: newDescription, imageName: newImageName)
        let _ = try await self.makeRequest(method: .patch, url: url, body: newUserInfo,
                                           serviceName: serviceName, methodName: methodName)
    }
    
    
    func fetchAllUsers() async throws -> [User] {
        return try await fetchUsers(userIds: nil)
    }
    
    
    func fetchUsers(userIds: [String]? = nil) async throws -> [User] {
        let methodName = "fetchUsers"
        let queryItems = userIds?.joined(separator: ",") ?? ""
        let url = serviceURL.appending(queryItems: [URLQueryItem(name: "userIds", value: queryItems)])
        
        let data = try await self.makeRequest(method: .get, url: url, serviceName: serviceName, methodName: methodName)
        let users = try await self.decodeUsers(from: data, methodName: methodName)
        return users
    }
    
    
    func createFriendRequest(userFromId: String, userToId: String) async throws {
        let methodName = "createFriendRequest"
        let url = serviceURL.appendingPathComponent("\(userFromId)/friends")
        
        let friendRequest = FriendRequest(friendUserId: userToId)
        let _ = try await self.makeRequest(method: .post, url: url, body: friendRequest, serviceName: serviceName, methodName: methodName)
    }
    
    
    func declineFriendRequest(userFromId: String, userToId: String) async throws {
        let methodName = "declineFriendRequest"
        let url = serviceURL.appendingPathComponent("\(userFromId)/friends/\(userToId)")
        
        let _ = try await self.makeRequest(method: .delete, url: url, serviceName: serviceName, methodName: methodName)
    }
    
    
    func fetchFriendRequests(userId: String) async throws -> [User] {
        let methodName = "fetchFriendRequests"
        let url = serviceURL.appendingPathComponent("\(userId)/friends/requests")
        
        let data = try await self.makeRequest(method: .get, url: url, serviceName: serviceName, methodName: methodName)
        let users = try await self.decodeUsers(from: data, methodName: methodName)
        return users
    }
    
    
    func fetchFriendsUpdates(userId: String, limit: Int = 30) async throws -> [FriendUpdate] {
        let methodName = "fetchFriendsUpdates"
        let url = serviceURL
            .appendingPathComponent("\(userId)/friends/updates")
            .appending(queryItems: [URLQueryItem(name: "limit", value: String(limit))])
        
        let data = try await self.makeRequest(method: .get, url: url, serviceName: serviceName, methodName: methodName)
        let updates = try self.decodeResponse(from: data, as: [FriendUpdateWrapper].self, serviceName: serviceName, methodName: methodName)
        
        var responseUpdates: [FriendUpdate] = []
        for update in updates {
            do {
                let update = try await friendUpdateMapper.mapToFriendUpdate(from: update)
                responseUpdates.append(update)
            } catch {
                print("Failed to convert: \(error.localizedDescription)")
            }
        }
        
        return responseUpdates
    }
    
    
    private func decodeUsers(from data: Data, methodName: String) async throws -> [User] {
        let users = try self.decodeResponse(from: data, as: [UserWrapper].self, serviceName: serviceName, methodName: methodName)
        
        var responseUsers: [User] = []
        for user in users {
            let mappedUser = await userMapper.mapToUser(from: user)
            responseUsers.append(mappedUser)
        }
        
        return responseUsers
    }
}
