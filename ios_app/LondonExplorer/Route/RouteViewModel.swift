//
//  RouteViewModel.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 20.06.2024.
//

import Foundation
import SwiftUI

class RouteViewModel: ObservableObject {
    @Published var route: Route
    @Published var isEditSheetPresented: Bool = false
    @Published var newName: String
    @Published var newDescription: String
    @Published var images: [UIImage]
    @Published var error: String = ""
    
    private var routesService = RoutesService()
    
    init(route: Route) {
        self.route = route
        self.newName = route.name
        self.newDescription = route.description
        self.images = route.stops.compactMap { stop in
            stop.attraction.images.first
        }
    }
    
    func saveEditRoute() {
        Task {
            do {
                var updatedRoute = self.route
                updatedRoute.name = self.newName
                updatedRoute.description = self.newDescription
                
                try await routesService.updateRoute(updatedRoute: updatedRoute)
                
                DispatchQueue.main.async {
                    self.route = updatedRoute
                    self.isEditSheetPresented = false
                }
            } catch {
                
            }
        }
    }
    
    func cancelEditRoute() {
        isEditSheetPresented = false
        newName = route.name
        newDescription = route.description
    }
    
    func deleteRoute() throws {
        Task {
            do {
                try await routesService.deleteRoute(routeId: route.id)
            } catch {
                print("Error deleting route")
                throw error
            }
        }
    }
}
