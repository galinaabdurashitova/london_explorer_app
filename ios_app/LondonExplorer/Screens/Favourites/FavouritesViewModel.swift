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
    
    private var routesService: RoutesServiceProtocol = RoutesService()
    
    @MainActor
    func loadRoutes(user: User) async {
        self.isLoading = true
        self.error = false
        do {
            self.savedRoutes = try await routesService.fetchFavouriteRoutes(userId: user.id)
        } catch {
            self.error = true
        }
        self.isLoading = false
    }
}
