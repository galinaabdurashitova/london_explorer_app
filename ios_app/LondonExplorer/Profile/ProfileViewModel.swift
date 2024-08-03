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
    
    private var routesService = RoutesService()
    
    init(user: User) {
        self.user = user
        self.loadRoutes()
    }
    
    func loadRoutes() {
        Task {
            do {
                if let userRoutes = try await routesService.fetchUserRoutes(userId: user.id) {
                    DispatchQueue.main.async {
                        self.routes = userRoutes.sorted(by: { $0.dateCreated > $1.dateCreated })
                    }
                }
            } catch {
                //
            }
        }
    }
}
