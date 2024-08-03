//
//  RoutesService.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 24.07.2024.
//

import Foundation

protocol RoutesServiceProtocol {
    func fetchRoute(routeId: String) async throws -> Route
    func fetchUserRoutes(userId: String) async throws -> [Route]?
    func fetchRoutes(routesIds: [String]) async throws -> [Route]
    func createRoute(newRoute: Route) async throws
    func updateRoute(updatedRoute: Route) async throws
    func deleteRoute(routeId: String) async throws
}

class RoutesService: RoutesServiceProtocol {
    private let baseURL = URL(string: "https://c490973c-0f21-4e71-866e-f8e4c353507b-00-3j1hu3pc5bvs1.kirk.replit.dev/api/routes")!
    
    @RoutesStorage(key: "LONDON_EXPLORER_ROUTES") var savedRoutes: [Route]
    
    enum ServiceError: Error {
        case noData
        case invalidResponse
        case serverError(Int)
    }
    
    func fetchRoute(routeId: String) async throws -> Route {
        if let route = savedRoutes.first(where: {
            $0.id == routeId
        }) {
            return route
        } else {
            throw ServiceError.serverError(404)
        }
    }
    
    func fetchUserRoutes(userId: String) async throws -> [Route]? {
        return savedRoutes.filter {
            $0.userCreated.id == userId
        }
    }
    
    func fetchRoutes(routesIds: [String]) async throws -> [Route] {
        let routes = savedRoutes.filter {
            routesIds.contains($0.id)
        }
        
        if routes.count > 0 {
            return routes
        } else {
            throw ServiceError.serverError(404)
        }
    }
    
    func createRoute(newRoute: Route) async throws {
        savedRoutes.append(newRoute)
    }
    
    func updateRoute(updatedRoute: Route) async throws {
        if let routeIndex = savedRoutes.firstIndex(where: {
            $0.id == updatedRoute.id
        }) {
            savedRoutes[routeIndex] = updatedRoute
        } else {
            throw ServiceError.serverError(404)
        }
    }
    
    func deleteRoute(routeId: String) async throws {
        savedRoutes.removeAll(where: { $0.id == routeId })
    }
}
