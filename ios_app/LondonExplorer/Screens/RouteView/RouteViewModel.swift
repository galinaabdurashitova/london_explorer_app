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
    @Published var userCreated: User?
    @Published var isEditSheetPresented: Bool = false
    @Published var newName: String
    @Published var newDescription: String
    @Published var images: [UIImage]
    @Published var confirmDelete: Bool = false
    @Published var editError: String?
    
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
    
    func fetchUserCreated() {
        Task {
            do {
                let user = try await userService.fetchUser(userId: self.route.userCreated)
                
                DispatchQueue.main.async {
                    self.userCreated = user
                }
            } catch {
                print("Unable to get user created")
            }
        }
    }
    
    func saveEditRoute() {
        do {
            self.editError = nil
            
            try routesManager.editRoute(routeId: self.route.id,
                                        newName: self.newName.isEmpty ? nil : self.newName,
                                        newDescription: self.newDescription.isEmpty ? nil : self.newDescription)
            
            DispatchQueue.main.async {
                self.route.name = self.newName
                self.route.description = self.newDescription
                self.isEditSheetPresented = false
            }
        } catch {
            self.editError = error.localizedDescription
        }
    }
    
    func cancelEditRoute() {
        isEditSheetPresented = false
        newName = route.name
        newDescription = route.description
    }
    
    func deleteRoute() {
        routesManager.deleteRoute(routeId: route.id)
    }
}
