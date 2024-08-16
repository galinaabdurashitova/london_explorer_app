//
//  CurrentRouteManager.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 04.08.2024.
//

import Foundation
import SwiftUI

class CurrentRouteManager: ObservableObject {
    @CurrentRoutesStorage(key: "LONDON_EXPLORER_CURRENT_ROUTES") var savedRoutesProgress: [RouteProgress]
    @Published var routeProgress: RouteProgress? {
        didSet {
            if let routeProgress = routeProgress {
                saveRoute(routeProgress: routeProgress)
            } else if let oldRouteProgress = oldValue {
                eraseProgress(user: oldRouteProgress.user)
            }
        }
    }
    
    func getMyRouteProgress(user: User) {
        if !savedRoutesProgress.isEmpty {
            if let routeProgress = savedRoutesProgress.first(where: {
                $0.user.id == user.id
            }) {
                self.routeProgress = routeProgress
            }
        }
    }
    
    private func getMyRouteProgressIndex(user: User) -> Int? {
        if !savedRoutesProgress.isEmpty {
            if let routeProgress = savedRoutesProgress.firstIndex(where: {
                $0.user.id == user.id
            }) {
                return routeProgress
            }
        }
        return nil
    }
    
    private func saveRoute(routeProgress: RouteProgress) {
        if let savedRouteIndex = getMyRouteProgressIndex(user: routeProgress.user) {
            savedRoutesProgress[savedRouteIndex] = routeProgress
        } else {
            savedRoutesProgress.append(routeProgress)
        }
    }
    
    private func eraseProgress(user: User) {
        savedRoutesProgress.removeAll(where: {
            $0.user.id == user.id
        })
    }
    
    func routeDeletion(route: Route) {
        if let routeProgress = routeProgress, routeProgress.route.id == route.id {
            self.routeProgress = nil
        }
        
        let newRPArray = savedRoutesProgress.filter { $0.route.id != route.id }
        savedRoutesProgress.removeAll()
        savedRoutesProgress = newRPArray
    }
}
