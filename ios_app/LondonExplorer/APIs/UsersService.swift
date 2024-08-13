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
    private let baseURL = URL(string: "http://localhost:8080/api/users")!
    
    func fetchUser(userId: String) async throws -> User {
        let url = baseURL.appending(queryItems: [URLQueryItem(name: "userId", value: userId)])
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw ServiceError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200..<300:
            break
        case 400:
            throw ServiceError.serverError(400)
        case 404:
            throw ServiceError.serverError(404)
        case 500:
            throw ServiceError.serverError(500)
        default:
            throw ServiceError.serverError(httpResponse.statusCode)
        }
        
        do {
            let user = try JSONDecoder().decode(UserWrapper.self, from: data)
            var userAwards: [User.UserAward] = []
            
            for award in user.awards {
                if let awardDate = DateConverter(format: "yyyy-MM-dd'T'HH:mm:ss.SSSZ").toDate(from: award.awardDate), let awardType = AwardTypes(rawValue: award.award) {
                    userAwards.append(
                        User.UserAward(
                            id: award.awardId,
                            type: awardType,
                            level: award.awardLevel,
                            date: awardDate
                        )
                    )
                } else {
                    print("Failed to convert award date \(award.awardDate) or award type for award \(award.award)")
                }
            }
            
            var userCollectables: [User.UserCollectable] = []
            
            for collectable in user.collectables {
                if let collectableType = Collectable(rawValue: collectable.collectable) {
                    userCollectables.append(
                        User.UserCollectable(
                            id: collectable.collectableId,
                            type: collectableType,
                            finishedRouteId: collectable.finishedRouteId
                        )
                    )
                } else {
                    print("Failed to convert collectable type for collectable \(collectable.collectable)")
                }
            }
            
            var finishedRoutes: [User.FinishedRoute] = []
            
            for route in user.finishedRoutes {
                if let finishedDate = DateConverter(format: "yyyy-MM-dd'T'HH:mm:ss.SSSZ").toDate(from: route.finishedDate) {
                    finishedRoutes.append(
                        User.FinishedRoute(
                            id: route.finishedRouteId,
                            routeId: route.routeId,
                            finishedDate: finishedDate,
                            collectables: route.collectables
                        )
                    )
                } else {
                    print("Failed to convert finished date \(route.finishedDate) for finished route \(route.finishedRouteId)")
                }
            }
            
            return User(
                userId: user.userId,
                email: user.email,
                name: user.name,
                userName: user.userName,
                userDescription: user.description,
                awards: userAwards,
                collectables: userCollectables,
                friends: user.friends,
                finishedRoutes: finishedRoutes.sorted { $0.finishedDate > $1.finishedDate }
            )
        } catch let error {
            if let decodingError = error as? DecodingError {
                throw NSError(domain: "UsersService", code: 1, userInfo: [NSLocalizedDescriptionKey: "Decoding error: \(decodingError.localizedDescription)"])
            } else {
                throw error
            }
        }
    }
    
    func createUser(newUser: User) async throws {
        var request = URLRequest(url: baseURL)
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
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw ServiceError.invalidResponse
            }
            
            switch httpResponse.statusCode {
            case 200..<300:
                break
            case 400:
                throw ServiceError.serverError(400)
            case 404:
                throw ServiceError.serverError(404)
            case 500:
                throw ServiceError.serverError(500)
            default:
                throw ServiceError.serverError(httpResponse.statusCode)
            }
            
        } catch let encodingError as EncodingError {
            throw NSError(domain: "UsersService", code: 1, userInfo: [NSLocalizedDescriptionKey: "Encoding error: \(encodingError.localizedDescription)"])
        } catch {
            throw error
        }
    }
    
    func saveFinishedRoute(userId: String, route: RouteProgress) async throws {
        guard let endTime = route.endTime else { throw ServiceError.serverError(400) }
        
        let url = baseURL.appendingPathComponent("\(userId)/finishedRoutes")
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
            finishedDate: DateConverter(format: "yyyy-MM-dd'T'HH:mm:ss.SSSZ").toString(from: endTime),
            userCollectables: newCollectables
        )
        
        do {
            let jsonData = try JSONEncoder().encode(newFinishedRouteWrapped)
            request.httpBody = jsonData
            
            let (_, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw ServiceError.invalidResponse
            }
            
            switch httpResponse.statusCode {
            case 200..<300:
                break
            case 400:
                throw ServiceError.serverError(400)
            case 404:
                throw ServiceError.serverError(404)
            case 500:
                throw ServiceError.serverError(500)
            default:
                throw ServiceError.serverError(httpResponse.statusCode)
            }
            
        } catch let encodingError as EncodingError {
            throw NSError(domain: "UsersService", code: 1, userInfo: [NSLocalizedDescriptionKey: "Encoding error: \(encodingError.localizedDescription)"])
        } catch {
            throw error
        }
    }
}
