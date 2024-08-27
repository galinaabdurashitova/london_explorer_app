//
//  RouteViewModel.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 20.06.2024.
//

import Foundation
import SwiftUI

class RouteViewModel: ObservableObject {
    // Data
    @Published var route: Route
    @Published var userCreated: User?
    @Published var images: [UIImage]
    
    // Edit
    @Published var isEditSheetPresented: Bool = false
    @Published var newName: String
    @Published var newDescription: String
    @Published var editError: String?
    
    // Delete
    @Published var confirmDelete: Bool = false
    
    // Publish
    @Published var isPublishing: Bool = false
    
    // Save(like)
    @Published var isSaving: Bool = false
    
    // Errors
    @Published var showError: Bool = false
    @Published var errorText: String = ""
    
    private var userService: UsersServiceProtocol = UsersService()
    private var routesService: RoutesServiceProtocol = RoutesService()
    private var routesManager: RoutesStorageManager = RoutesStorageManager()
    
    init(route: Route) {
        self.route = route
        self.newName = route.name
        self.newDescription = route.description
        self.images = route.stops.compactMap { stop in
            stop.attraction.images.first
        }
    }
    
    // Fetch user - service
    @MainActor
    func fetchUserCreated() async {
        do {
            let user = try await userService.fetchUser(userId: self.route.userCreated)
            self.userCreated = user
        } catch {
            print("Unable to get user created")
        }
    }
    
    // Edit route - local
    @MainActor
    func saveEditRoute() {
        do {
            self.editError = nil
            
            try routesManager.editRoute(routeId: self.route.id,
                                        newName: self.newName.isEmpty ? nil : self.newName,
                                        newDescription: self.newDescription.isEmpty ? nil : self.newDescription)
            
            self.route.name = self.newName
            self.route.description = self.newDescription
            self.isEditSheetPresented = false
        } catch {
            self.editError = error.localizedDescription
        }
    }
    
    @MainActor
    func cancelEditRoute() {
        self.isEditSheetPresented = false
        self.newName = route.name
        self.newDescription = route.description
    }
    
    // Delete route - local
    func deleteRoute() {
        routesManager.deleteRoute(routeId: route.id)
    }
    
    // Publish route - service
    @MainActor
    func publishRoute() async {
        do {
            try await routesService.createRoute(newRoute: route)
            self.route.datePublished = Date()
            routesManager.deleteRoute(routeId: self.route.id)
        } catch {
            self.errorText = error.localizedDescription
            self.showError = true
        }
    }
    
    // Route likes and dislike - service
    @MainActor
    func saveRoute(user: User) async {
        do {
            try await routesService.likeRoute(routeId: route.id, userId: user.id)
            route.saves.append(user.id)
        } catch {
            self.errorText = error.localizedDescription
            self.showError = true
        }
    }
    
    @MainActor
    func dislikeRoute(user: User) async {
        do {
            try await routesService.dislikeRoute(routeId: route.id, userId: user.id)
            route.saves.removeAll(where: { $0 == user.id })
        } catch {
            self.errorText = error.localizedDescription
            self.showError = true
        }
    }
}
