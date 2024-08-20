//
//  RoutesService.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 24.07.2024.
//

import Foundation

protocol RoutesServiceProtocol: Service {
    func fetchRoute(routeId: String) async throws -> Route
    func fetchUserRoutes(userId: String) async throws -> [Route]?
    func fetchRoutes(routesIds: [String]) async throws -> [Route]
    func createRoute(newRoute: Route) async throws
    func updateRoute(updatedRoute: Route) async throws
    func deleteRoute(routeId: String) async throws
}

class RoutesService: Service, RoutesServiceProtocol {
    private lazy var serviceURL: URL = {
        return baseURL.appendingPathComponent("routes")
    }()
    
    override init() {
        super.init()
    }
    
    @RoutesStorage(key: "LONDON_EXPLORER_ROUTES") var savedRoutes: [Route]
    
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
