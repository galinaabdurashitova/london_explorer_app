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
    func updateUserInfo(userId: String,
                        newName: String?,
                        newUserName: String?,
                        newDescription: String?) async throws                       // Update user
    func fetchUsers(userIds: [String]?) async throws -> [User]                      // Get all users/by IDs
    func createFriendRequest(userFromId: String, userToId: String) async throws     // Send/confirm friend request
    func declineFriendRequest(userFromId: String, userToId: String) async throws    // Decline friend request
    func fetchFriendRequests(userId: String) async throws -> [User]                 // Get friendship requests
    func fetchFriendsUpdates(userId: String, limit: Int) async throws -> [FriendUpdate] // Get friends updates
}

class UsersService: Service, UsersServiceProtocol {
    private lazy var serviceURL: URL = {
        return baseURL.appendingPathComponent("users")
    }()
    
    override init() {
        super.init()
    }
    
    func fetchUser(userId: String) async throws -> User {
        let url = serviceURL.appendingPathComponent("\(userId)")
        let (data, response) = try await URLSession.shared.data(from: url)

        do {
            try self.checkResponse(response: response, service: "Users service", method: "fetchUser")
            let user = try JSONDecoder().decode(UserWrapper.self, from: data)
            return self.convertUser(userWrapper: user)
        } catch let error {
            if let decodingError = error as? DecodingError {
                throw NSError(domain: "UsersService", code: 1, userInfo: [NSLocalizedDescriptionKey: "Decoding error: \(decodingError.localizedDescription)"])
            } else {
                throw error
            }
        }
    }
    
    func createUser(newUser: User) async throws {
        var request = URLRequest(url: serviceURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let newUserWrapped = UserWrapper(
            userId: newUser.id,
            email: newUser.email,
            name: newUser.name,
            userName: newUser.userName
        )
        
        do {
            let jsonData = try JSONEncoder().encode(newUserWrapped)
            request.httpBody = jsonData
            let (_, response) = try await URLSession.shared.data(for: request)
            try self.checkResponse(response: response, service: "Users service", method: "createUser")
        } catch let encodingError as EncodingError {
            throw NSError(domain: "UsersService", code: 1, userInfo: [NSLocalizedDescriptionKey: "Encoding error: \(encodingError.localizedDescription)"])
        } catch {
            throw error
        }
    }
    
    func saveFinishedRoute(userId: String, route: RouteProgress) async throws {
        guard let endTime = route.endTime else { throw ServiceError.serverError(400) }
        
        let url = serviceURL.appendingPathComponent("\(userId)/finishedRoutes")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        var newCollectables: [FinishedRouteWrapper.UserCollectable] = []
        
        for collectable in route.collectables {
            newCollectables.append(
                FinishedRouteWrapper.UserCollectable(userCollectableId: collectable.id, collectable: collectable.type.rawValue)
            )
        }
        
        let newFinishedRouteWrapped = FinishedRouteWrapper(
            routeId: route.route.id,
            spentMinutes: route.totalElapsedMinutes(),
            finishedDate: DateConverter(format: "yyyy-MM-dd'T'HH:mm:ss.SSSZ").toString(from: endTime),
            userCollectables: newCollectables
        )
        
        do {
            let jsonData = try JSONEncoder().encode(newFinishedRouteWrapped)
            request.httpBody = jsonData
            let (_, response) = try await URLSession.shared.data(for: request)
            try self.checkResponse(response: response, service: "Users service", method: "saveFinishedRoute")
        } catch let encodingError as EncodingError {
            throw NSError(domain: "UsersService", code: 1, userInfo: [NSLocalizedDescriptionKey: "Encoding error: \(encodingError.localizedDescription)"])
        } catch {
            throw error
        }
    }
    
    func saveUserAward(userId: String, awards: [User.UserAward]) async throws {
        let url = serviceURL.appendingPathComponent("\(userId)/awards")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        var newAwards: [UserWrapper.UserAward] = []
        
        for award in awards {
            let newAward = UserWrapper.UserAward(
                userAwardId: award.id,
                award: award.type.rawValue,
                awardLevel: award.level,
                awardDate: DateConverter(format: "yyyy-MM-dd'T'HH:mm:ss.SSSZ").toString(from: award.date)
            )
            
            newAwards.append(newAward)
        }
        
        do {
            let jsonData = try JSONEncoder().encode(newAwards)
            request.httpBody = jsonData
            let (_, response) = try await URLSession.shared.data(for: request)
            try self.checkResponse(response: response, service: "Users service", method: "saveUserAward")
        } catch let encodingError as EncodingError {
            throw NSError(domain: "UsersService", code: 1, userInfo: [NSLocalizedDescriptionKey: "Encoding error: \(encodingError.localizedDescription)"])
        } catch {
            throw error
        }
    }
    
    func updateUserInfo(userId: String,
                        newName: String? = nil,
                        newUserName: String? = nil,
                        newDescription: String? = nil) async throws {
        let newUserInfo = UpdateUserRequest(name: newName, userName: newUserName, description: newDescription)
        
        let url = serviceURL.appendingPathComponent("\(userId)")
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        
        do {
            let jsonData = try JSONEncoder().encode(newUserInfo)
            request.httpBody = jsonData
            let (_, response) = try await URLSession.shared.data(for: request)
            try self.checkResponse(response: response, service: "Users service", method: "updateUserInfo")
        } catch let encodingError as EncodingError {
            throw NSError(domain: "UsersService", code: 1, userInfo: [NSLocalizedDescriptionKey: "Encoding error: \(encodingError.localizedDescription)"])
        } catch {
            throw error
        }
    }
    
    func fetchUsers(userIds: [String]?) async throws -> [User] {
        let queryItems = userIds?.joined(separator: ",") ?? ""
        let url = serviceURL.appending(queryItems: [URLQueryItem(name: "userIds", value: queryItems)])
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        do {
            try self.checkResponse(response: response, service: "Users service", method: "fetchUsers")
            let users = try JSONDecoder().decode([UserWrapper].self, from: data)
            
            var responseUsers: [User] = []
            for user in users {
                responseUsers.append(self.convertUser(userWrapper: user))
            }
            
            return responseUsers
        } catch let error {
            if let decodingError = error as? DecodingError {
                throw NSError(domain: "UsersService", code: 1, userInfo: [NSLocalizedDescriptionKey: "Decoding error: \(decodingError.localizedDescription)"])
            } else {
                throw error
            }
        }
    }
    
    func createFriendRequest(userFromId: String, userToId: String) async throws {
        let url = serviceURL.appendingPathComponent("\(userFromId)/friends")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let friendRequest = FriendRequest(friendUserId: userToId)
        
        do {
            let jsonData = try JSONEncoder().encode(friendRequest)
            request.httpBody = jsonData
            let (_, response) = try await URLSession.shared.data(for: request)
            try self.checkResponse(response: response, service: "Users service", method: "createFriendRequest")
        } catch let encodingError as EncodingError {
            throw NSError(domain: "UsersService", code: 1, userInfo: [NSLocalizedDescriptionKey: "Encoding error: \(encodingError.localizedDescription)"])
        } catch {
            throw error
        }
    }
    
    func declineFriendRequest(userFromId: String, userToId: String) async throws {
        let url = serviceURL.appendingPathComponent("\(userFromId)/friends/\(userToId)")
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            let jsonString = String(data: data, encoding: .utf8)
            print("Received JSON: \(jsonString ?? "No Data")")
            try self.checkResponse(response: response, service: "Users service", method: "declineFriendRequest")
        } catch {
            throw error
        }
    }
    
    func fetchFriendRequests(userId: String) async throws -> [User] {
        let url = serviceURL.appendingPathComponent("\(userId)/friends/requests")
        let (data, response) = try await URLSession.shared.data(from: url)
        
        do {
            try self.checkResponse(response: response, service: "Users service", method: "fetchFriendRequests")
            let users = try JSONDecoder().decode([UserWrapper].self, from: data)
            
            var responseUsers: [User] = []
            for user in users {
                responseUsers.append(self.convertUser(userWrapper: user))
            }
            
            return responseUsers
        } catch let error {
            if let decodingError = error as? DecodingError {
                throw NSError(domain: "UsersService", code: 1, userInfo: [NSLocalizedDescriptionKey: "Decoding error: \(decodingError.localizedDescription)"])
            } else {
                throw error
            }
        }
    }
    
    func fetchFriendsUpdates(userId: String, limit: Int = 30) async throws -> [FriendUpdate] {
        var url = serviceURL.appendingPathComponent("\(userId)/friends/updates")
        url = url.appending(queryItems: [URLQueryItem(name: "limit", value: String(limit))])
        let (data, response) = try await URLSession.shared.data(from: url)
        
        do {
            try self.checkResponse(response: response, service: "Users service", method: "fetchFriendsUpdates")
            let updates = try JSONDecoder().decode([FriendUpdateWrapper].self, from: data)
            
            var responseUpdates: [FriendUpdate] = []
            for update in updates {
                if let updateType = FriendUpdate.UpdateType(rawValue: update.updateType), let date = DateConverter(format: "yyyy-MM-dd'T'HH:mm:ss.SSSZ").toDate(from: update.updateDate) {
                    responseUpdates.append(
                        FriendUpdate(
                            friend: User(
                                userId: update.userId,
                                name: update.name,
                                userName: update.userName
                            ),
                            description: update.description,
                            date: date,
                            update: updateType
                        )
                    )
                } else {
                    print("Failed to convert update date \(update.updateDate) or update type \(update.updateType)")
                }
            }
            
            return responseUpdates
        } catch let error {
            if let decodingError = error as? DecodingError {               
                switch decodingError {
                case .typeMismatch(let key, let context):
                    print("User service fetchUserProfile: decoding error - Type mismatch for key \(key) in context \(context.debugDescription)")
                case .valueNotFound(let key, let context):
                    print("User service fetchUserProfile: decoding error - Value not found for key \(key) in context \(context.debugDescription)")
                case .keyNotFound(let key, let context):
                    print("User service fetchUserProfile: decoding error - Key '\(key)' not found: \(context.debugDescription)")
                case .dataCorrupted(let context):
                    print("User service fetchUserProfile: decoding error - Data corrupted: \(context.debugDescription)")
                @unknown default:
                    print("User service fetchUserProfile: decoding error - Unknown decoding error")
                }
                throw NSError(domain: "UsersService", code: 1, userInfo: [NSLocalizedDescriptionKey: "Decoding error: \(decodingError.localizedDescription)"])
            } else {
                print(error.localizedDescription)
                throw error
            }
        }
    }
    
    private func convertUser(userWrapper: UserWrapper) -> User {
        var userAwards: [User.UserAward] = []
        
        if let awards = userWrapper.awards {
            for award in awards {
                if let awardDate = DateConverter(format: "yyyy-MM-dd'T'HH:mm:ss.SSSZ").toDate(from: award.awardDate), let awardType = AwardTypes(rawValue: award.award) {
                    userAwards.append(
                        User.UserAward(
                            id: award.userAwardId,
                            type: awardType,
                            level: award.awardLevel,
                            date: awardDate
                        )
                    )
                } else {
                    print("Failed to convert award date \(award.awardDate) or award type for award \(award.award)")
                }
            }
        }
        
        var userCollectables: [User.UserCollectable] = []
        
        if let collectables = userWrapper.collectables {
            for collectable in collectables {
                if let collectableType = Collectable(rawValue: collectable.collectable) {
                    userCollectables.append(
                        User.UserCollectable(
                            id: collectable.userCollectableId,
                            type: collectableType,
                            finishedRouteId: collectable.finishedRouteId
                        )
                    )
                } else {
                    print("Failed to convert collectable type for collectable \(collectable.collectable)")
                }
            }
        }
        
        var finishedRoutes: [User.FinishedRoute] = []
        
        if let routes = userWrapper.finishedRoutes {
            for route in routes {
                if let finishedDate = DateConverter(format: "yyyy-MM-dd'T'HH:mm:ss.SSSZ").toDate(from: route.finishedDate) {
                    finishedRoutes.append(
                        User.FinishedRoute(
                            id: route.finishedRouteId,
                            routeId: route.routeId,
                            spentMinutes: route.spentMinutes,
                            finishedDate: finishedDate,
                            collectables: route.collectables
                        )
                    )
                } else {
                    print("Failed to convert finished date \(route.finishedDate) for finished route \(route.finishedRouteId)")
                }
            }
        }
        
        return User(
            userId: userWrapper.userId,
            email: userWrapper.email,
            name: userWrapper.name,
            userName: userWrapper.userName.lowercased(),
            userDescription: userWrapper.description,
            awards: userAwards,
            collectables: userCollectables,
            friends: userWrapper.friends ?? [],
            finishedRoutes: finishedRoutes.sorted { $0.finishedDate > $1.finishedDate }
        )
    }
}
