//
//  ProfileViewModel.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 20.06.2024.
//

import Foundation
import SwiftUI

class ProfileViewModel: ObservableObject {
    @Published var routes: [Route] = []
    @Published var user: User
    @Published var error: String = ""
    
    private var userService: UsersServiceProtocol = UsersService()
    private var routesService: RoutesServiceProtocol = RoutesService()
    
    init(user: User) {
        self.user = user
        self.loadRoutes()
    }
    
    func fetchUser() {
        DispatchQueue.main.async {
            Task {
                do {
                    self.user = try await self.userService.fetchUser(userId: self.user.id)
                } catch {
                    self.error = error.localizedDescription
                }
            }
        }
    }
    
    func loadRoutes() {
        Task {
            // Get created routes
            do {
                if let userRoutes = try await routesService.fetchUserRoutes(userId: user.id) {
                    DispatchQueue.main.async {
                        self.routes = userRoutes.sorted(by: { $0.dateCreated > $1.dateCreated })
                    }
                }
            } catch {
                //
            }
            
            // Get finished routes
            for routeIndex in user.finishedRoutes.indices {
                do {
                    if user.finishedRoutes[routeIndex].route == nil {
                        let route = try await routesService.fetchRoute(routeId: user.finishedRoutes[routeIndex].routeId)
                        DispatchQueue.main.async {
                            self.user.finishedRoutes[routeIndex].route = route
                        }
                    }
                } catch {
                    print("Error fetching route \(user.finishedRoutes[routeIndex].id)")
                }
            }
        }
    }
}
