//
//  RoutesStorageManager.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 25.08.2024.
//

import Foundation

enum RouteStorageError: Error {
    case routeNotFound
    case invalidRequest
}

extension RouteStorageError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .routeNotFound:
            return NSLocalizedString("The specified route was not found.", comment: "Route Not Found Error")
        case .invalidRequest:
            return NSLocalizedString("The request was invalid.", comment: "Invalid Request Error")
        }
    }
}

class RoutesStorageManager {
    @RoutesStorage(key: "LONDON_EXPLORER_ROUTES") var savedRoutes: [Route]
    
    func saveRoute(route: Route) {
        savedRoutes.append(route)
    }
    
    func editRoute(routeId: String, newName: String? = nil, newDescription: String? = nil) throws {
        guard let routeIndex = savedRoutes.firstIndex(where: { $0.id == routeId }) else {
            print("Routes manager: route not found")
            throw RouteStorageError.routeNotFound
        }
        
        if newName == nil && newDescription == nil {
            print("Routes manager: no data to edit")
            throw RouteStorageError.invalidRequest
        }
        
        if let name = newName { savedRoutes[routeIndex].name = name }
        if let description = newDescription { savedRoutes[routeIndex].description = description }
    }
    
    func deleteRoute(routeId: String) {
        savedRoutes.removeAll(where: { $0.id == routeId })
    }
    
    func getUserRoute(userId: String) -> [Route] {
        return savedRoutes.filter({ $0.userCreated == userId })
    }
    
    func getRouteById(routeId: String) -> Route? {
        return savedRoutes.first(where: { $0.id == routeId })
    }
}
