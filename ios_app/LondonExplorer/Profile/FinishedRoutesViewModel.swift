//
//  FinishedRoutesViewModel.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 24.07.2024.
//

import Foundation
import SwiftUI

class FinishedRoutesViewModel: ObservableObject {
    @Published var finishedRoutes: [User.FinishedRoute] = []
    
    private var usersRepository: UsersServiceProtocol = UsersService()
    private var routesService = RoutesService()
    private var auth: AuthController?
    
    func setAuthController(_ auth: AuthController) {
        self.auth = auth
    }
    
    func loadRoutes() {
        if let auth = auth {
//            usersRepository.removeFinishedRoutes(userId: auth.profile.id)
            Task {
                var routes = auth.profile.finishedRoutes
                for routeIndex in routes.indices {
                    do {
                        let route = try await routesService.fetchRoute(routeId: routes[routeIndex].id)
                        routes[routeIndex].route = route
                    } catch {
                        print("Error fetching route \(routes[routeIndex].id)")
                    }
                }
                
                DispatchQueue.main.async {
                    self.finishedRoutes = routes
                }
            }
        }
    }
}
