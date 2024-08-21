//
//  SearchViewModel.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 20.08.2024.
//

import Foundation
import SwiftUI

class SearchViewModel: ObservableObject {
    @Published var searchedUser: String = ""
    @Published var users: [User] = []
    @Published var filteredUsers: [User] = []
    @Published var searchedRoute: String = ""
    @Published var routes: [Route] = []
    @Published var filteredRoutes: [Route] = []
    
    private var userService: UsersServiceProtocol = UsersService()
    private var routesService: RoutesServiceProtocol = RoutesService()
    
    init() {
        self.fetchUsers()
        self.fetchRoutes()
    }
    
    func fetchUsers() {
        DispatchQueue.main.async {
            Task {
                self.users = try await self.userService.fetchUsers(userIds: nil)
            }
        }
    }
    
    func filterUsers() {
        var tempUsers = users
        
        if !searchedUser.isEmpty {
            tempUsers = tempUsers.filter { user in
                user.name.lowercased().contains(searchedUser.lowercased()) ||
                user.userName.lowercased().contains(searchedUser.lowercased()) ||
                (user.description != nil && user.description!.lowercased().contains(searchedUser.lowercased()))
            }
        }
        
        DispatchQueue.main.async {
            self.filteredUsers = tempUsers
        }
    }
    
    func fetchRoutes() {
        DispatchQueue.main.async {
            Task {
                self.routes = try await self.routesService.fetchRoutes(routesIds: nil)
            }
        }
    }
    
    func filterRoutes() {
        var tempRoutes = routes
        
        if !searchedRoute.isEmpty {
            tempRoutes = tempRoutes.filter { route in
                route.name.lowercased().contains(searchedRoute.lowercased()) ||
                route.description.lowercased().contains(searchedRoute.lowercased())
            }
        }
        
        DispatchQueue.main.async {
            self.filteredRoutes = tempRoutes
        }
    }
}
