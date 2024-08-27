//
//  FavouritesViewModel.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 26.08.2024.
//

import Foundation
import SwiftUI

class FavouritesViewModel: ObservableObject {
    @Published var savedRoutes: [Route] = []
    @Published var isLoading: Bool = false
    @Published var error: Bool = false
    
    private var user: User
    
    private var routesService: RoutesServiceProtocol = RoutesService()
    
    init(user: User) {
        self.user = user
    }
    
    @MainActor
    func loadRoutes() {
        self.isLoading =  true
        self.error = false
        
        Task {
            do {
                let routes = try await routesService.fetchFavouriteRoutes(userId: user.id)
                savedRoutes = routes
            } catch {
                self.error = true
            }
            self.isLoading = false
        }
    }
}
