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
    
    private var userService: UsersServiceProtocol = UsersService()
    
    init() {
        self.fetchUsers()
    }
    
    func fetchUsers() {
        Task {
            self.users = try await userService.fetchUsers(userIds: nil)
        }
    }
    
    func filterUsers() {
        var tempUsers = users
        
        if !searchedUser.isEmpty {
            tempUsers = tempUsers.filter { user in
                user.name.lowercased().contains(searchedUser.lowercased()) ||
                user.userName.lowercased().contains(searchedUser.lowercased())
            }
        }
        
        filteredUsers = tempUsers
    }
}
