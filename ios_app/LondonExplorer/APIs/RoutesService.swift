//
//  RoutesService.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 24.07.2024.
//

import Foundation

protocol RoutesServiceProtocol: Service {
    func fetchRoute(routeId: String) async throws -> Route              // Get route by id
    func fetchUserRoutes(userId: String) async throws -> [Route]        // Get routes by user
    func fetchAllRoutes() async throws -> [Route]                       // Get all routes
    func fetchRoutes(routesIds: [String]?) async throws -> [Route]      // Get routes by IDs
    func createRoute(newRoute: Route) async throws                      // Create route
    func updateRoute(routeId: String, newName: String?,
                     newDescription: String?) async throws              // Update route
    func likeRoute(routeId: String, userId: String) async throws        // Like route
    func dislikeRoute(routeId: String, userId: String) async throws     // Dislike route
    func fetchFavouriteRoutes(userId: String) async throws -> [Route]   // Get favourite routes
    func fetchTopRoutes(limit: Int) async throws -> [Route]             // Get top routes
}

class RoutesService: Service, RoutesServiceProtocol {
    private let serviceURL = URL(string: "http://localhost:8082/api/routes")!
    private let serviceName = "Routes service"
    
    private let routeMapper = RouteMapper()
    
    
    func fetchRoute(routeId: String) async throws -> Route {
        let methodName = "fetchRoute"
        let url = serviceURL.appendingPathComponent("\(routeId)")
        
        let data = try await self.makeRequest(method: .get, url: url, serviceName: serviceName, methodName: methodName)
        let route = try self.decodeResponse(from: data, as: RouteWrapper.self, serviceName: serviceName, methodName: methodName)
        let responseRoutes = try await routeMapper.mapToRoute(from: route)
        return responseRoutes
    }
    
    
    func fetchUserRoutes(userId: String) async throws -> [Route] {
        let methodName = "fetchUserRoutes"
        let url = serviceURL
            .appendingPathComponent("userCreated")
            .appending(queryItems: [URLQueryItem(name: "userId", value: userId)])
        
        let data = try await self.makeRequest(method: .get, url: url, serviceName: serviceName, methodName: methodName)
        return try await self.decodeRoutes(from: data, methodName: methodName)
    }
    
    
    func fetchAllRoutes() async throws -> [Route] {
        return try await self.fetchRoutes(routesIds: nil)
    }
    
    
    func fetchRoutes(routesIds: [String]? = nil) async throws -> [Route] {
        let methodName = "fetchUserRoutes"
        let queryItems = routesIds?.joined(separator: ",") ?? ""
        let url = serviceURL.appending(queryItems: [URLQueryItem(name: "routesIds", value: queryItems)])
        
        let data = try await self.makeRequest(method: .get, url: url, serviceName: serviceName, methodName: methodName)
        return try await self.decodeRoutes(from: data, methodName: methodName)
    }
    
    
    func createRoute(newRoute: Route) async throws {
        let methodName = "createRoute"
        
        let _ = try await self.makeRequest(method: .post, url: serviceURL, body: RouteWrapper(from: newRoute),
                                               serviceName: serviceName, methodName: methodName)
    }
    
    
    func updateRoute(routeId: String, newName: String? = nil, newDescription: String? = nil) async throws {
        let methodName = "updateRoute"
        let url = serviceURL.appendingPathComponent("\(routeId)")
        
        let newRouteInfo = RouteUpdateRequest(routeName: newName, routeDescription: newDescription)
        let _ = try await self.makeRequest(method: .patch, url: url, body: newRouteInfo,
                                           serviceName: serviceName, methodName: methodName)
    }
    
    
    func likeRoute(routeId: String, userId: String) async throws {
        let methodName = "likeRoute"
        let url = serviceURL.appendingPathComponent("\(routeId)/saves")
        
        let saveRouteRequest = RouteSaveRequest(userId: userId, saveDate: DateConverter(format: "yyyy-MM-dd'T'HH:mm:ss.SSSZ").toString(from: Date()))
        let _ = try await self.makeRequest(method: .post, url: url, body: saveRouteRequest,
                                           serviceName: serviceName, methodName: methodName)
    }
    
    
    func dislikeRoute(routeId: String, userId: String) async throws {
        let methodName = "dislikeRoute"
        let url = serviceURL.appendingPathComponent("\(routeId)/saves/\(userId)")
        
        let _ = try await self.makeRequest(method: .delete, url: url, serviceName: serviceName, methodName: methodName)
    }
    
    
    func fetchFavouriteRoutes(userId: String) async throws -> [Route] {
        let methodName = "fetchFavouriteRoutes"
        let url = serviceURL
            .appendingPathComponent("favourites")
            .appending(queryItems: [URLQueryItem(name: "userId", value: userId)])
        
        let data = try await self.makeRequest(method: .get, url: url, serviceName: serviceName, methodName: methodName)
        return try await self.decodeRoutes(from: data, methodName: methodName)
    }
    
    
    func fetchTopRoutes(limit: Int = 10) async throws -> [Route] {
        let methodName = "fetchTopRoutes"
        let url = serviceURL
            .appendingPathComponent("favourites/top")
            .appending(queryItems: [URLQueryItem(name: "limit", value: String(limit))])
        
        let data = try await self.makeRequest(method: .get, url: url, serviceName: serviceName, methodName: methodName)
        return try await self.decodeRoutes(from: data, methodName: methodName)
    }
    
    
    private func decodeRoutes(from data: Data, methodName: String) async throws -> [Route] {
        let routes = try self.decodeResponse(from: data, as: [RouteWrapper].self, serviceName: serviceName, methodName: methodName)
        
        var responseRoutes: [Route] = []
        for route in routes {
            do {
                let unwrappedRoute = try await routeMapper.mapToRoute(from: route)
                responseRoutes.append(unwrappedRoute)
            } catch {
                print("Unable to decode rotue: \(error.localizedDescription)")
            }
        }
        
        return responseRoutes
    }
}
