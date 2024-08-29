//
//  SuggestedRoutesViewModel.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 27.08.2024.
//

import Foundation
import SwiftUI

class SuggestedRoutesViewModel: ObservableObject {
    @Published var routes: [Route] = []
    @Published var isLoading: Bool = false
    @Published var error: Bool = false
    @Published var loaded: Bool = false
    
    private var routesService: RoutesServiceProtocol = RoutesService()
    
    @MainActor
    func loadRoutes() {
        self.isLoading = true
        self.error = false
        
        Task {
            do {
                self.routes = try await routesService.fetchTopRoutes(limit: 5)
                self.loaded = true
            } catch {
                print("LOADING ERROR: \(error.localizedDescription)")
                self.error = true
            }
            self.isLoading = false
        }
    }
}
