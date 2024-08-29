//
//  SearchViewModel.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 20.08.2024.
//

import Foundation
import SwiftUI

class SearchViewModel: ObservableObject {
    // Routes
    @Published var searchedRoute: String = ""
    @Published var routes: [Route] = []
    @Published var filteredRoutes: [Route] = []
    @Published var isFetchingRoutes: Bool = false
    @Published var errorRoutes: Bool = false
    
    // Users
    @Published var searchedUser: String = ""
    @Published var users: [User] = []
    @Published var filteredUsers: [User] = []
    @Published var isFetchingUsers: Bool = false
    @Published var errorUsers: Bool = false
    
    private var userService: UsersServiceProtocol = UsersService()
    private var routesService: RoutesServiceProtocol = RoutesService()
    
    @MainActor
    init() {
        self.getScreenData()
    }
    
    @MainActor
    func getScreenData() {
        self.isFetchingRoutes = true
        self.isFetchingUsers = true
        
        Task {
            await self.fetchRoutes()
            self.isFetchingRoutes = false
            
            await self.fetchUsers()
            self.isFetchingUsers = false
        }
    }
    
    @MainActor
    func fetchRoutes() async {
        self.errorRoutes = false
        do {
            self.routes = try await self.routesService.fetchAllRoutes()
        } catch {
            self.errorRoutes = true
        }
    }
    
    @MainActor
    func filterRoutes() {
        var tempRoutes = routes
        
        if !searchedRoute.isEmpty {
            tempRoutes = tempRoutes.filter { route in
                route.name.lowercased().contains(searchedRoute.lowercased()) ||
                route.description.lowercased().contains(searchedRoute.lowercased())
            }
        }
        
        self.filteredRoutes = tempRoutes
    }
    
    @MainActor
    func fetchUsers() async {
        self.errorUsers = false
        do {
            self.users = try await self.userService.fetchAllUsers()
        } catch {
            self.errorUsers = true
        }
    }
    
    @MainActor
    func filterUsers() {
        var tempUsers = users
        
        if !searchedUser.isEmpty {
            tempUsers = tempUsers.filter { user in
                user.name.lowercased().contains(searchedUser.lowercased()) ||
                user.userName.lowercased().contains(searchedUser.lowercased()) ||
                (user.description != nil && user.description!.lowercased().contains(searchedUser.lowercased()))
            }
        }
        
        self.filteredUsers = tempUsers
    }
}
