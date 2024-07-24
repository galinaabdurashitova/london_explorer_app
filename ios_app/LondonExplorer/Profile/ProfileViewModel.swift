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
    @RoutesStorage(key: "LONDON_EXPLORER_ROUTES") var savedRoutes: [Route]
    
    init(user: User) {
        self.user = user
        self.loadRoutes()
    }
    
    func loadRoutes() {
        self.routes = savedRoutes.sorted(by: { $0.dateCreated > $1.dateCreated })
    }
}
