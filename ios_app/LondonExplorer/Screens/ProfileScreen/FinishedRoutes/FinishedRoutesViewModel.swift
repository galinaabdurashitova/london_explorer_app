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
    @Published var user: User
    
    private var usersRepository: UsersServiceProtocol = UsersService()
    private var routesService = RoutesService()
    
    init(user: User) {
        self.user = user
        self.loadRoutes()
    }
    
    func loadRoutes() {
        DispatchQueue.main.async {
            Task {
                self.finishedRoutes = self.user.finishedRoutes
                
                for routeIndex in self.finishedRoutes.indices {
                    if self.finishedRoutes[routeIndex].route != nil {
                        do {
                            let route = try await self.routesService.fetchRoute(routeId: self.finishedRoutes[routeIndex].routeId)
                            self.finishedRoutes[routeIndex].route = route
                        } catch {
                            print("Error fetching route \(self.finishedRoutes[routeIndex].id)")
                        }
                    }
                }
            }
        }
    }
}
