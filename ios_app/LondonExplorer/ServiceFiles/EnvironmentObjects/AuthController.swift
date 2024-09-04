//
//  AuthController.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 23.07.2024.
//

import Foundation
import SwiftUI
import FirebaseCore
import FirebaseAuth

class AuthController: ObservableObject {
    @Published var isSignedIn = false
    @Published var isStarting = true
    @Published var isFetchingUser = false
    @Published var profile: User = User(userId: "", name: "", userName: "")
    
    private var usersRepository: UsersServiceProtocol = UsersService()
    private var routesRepository: RoutesServiceProtocol = RoutesService()
    
    init(testProfile: Bool = false) {
        if testProfile == true  {
            self.setUserProfile()
        } else {
            observeAuthChanges()
        }
    }
    
    @MainActor
    func reloadUser() async {
        self.isFetchingUser = true
        do {
            self.profile = try await self.usersRepository.fetchUser(userId: self.profile.id)
            await self.getFinishedRoutes()
        } catch {
            print("Error while fetching the user profile: \(error)")
        }
        self.isFetchingUser = false
        print("User reloaded")
    }
    
    func getFinishedRoutes() async {
        for routeIndex in self.profile.finishedRoutes.indices {
            do {
                let route = try await self.routesRepository.fetchRoute(routeId: self.profile.finishedRoutes[routeIndex].routeId)
                
                DispatchQueue.main.async {
                    self.profile.finishedRoutes[routeIndex].route = route
                }
            } catch {
                print("Error fetching route \(self.profile.finishedRoutes[routeIndex].id)")
            }
        }
    }
    
    
    private func setUserProfile(user: User = MockData.Users[0]) {
        DispatchQueue.main.async {
            self.profile = user
            Task { await self.getFinishedRoutes() }
        }
    }
    
    private func observeAuthChanges() {
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async {
                guard let user = user else {
                    DispatchQueue.main.async {
                        self?.isSignedIn = false
                        self?.isStarting = false
                    }
                    return
                }
                guard let self = self else { return }
                
                Task {
                    do {
                        let profile = try await self.usersRepository.fetchUser(userId: user.uid)
                        self.setUserProfile(user: profile)
                        self.isSignedIn = true
                        print("User \(user.uid) signed in.")
                    } catch {
                        print("Error while fetching the user profile: \(error)")
                    }
                    
                    self.isStarting = false
                }
            }
        }
    }
    
    @MainActor
    func login(email: String, password: String) async throws {
        do {
            let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
            let user = authResult.user
            
            let profile = try await usersRepository.fetchUser(userId: user.uid)
            
            self.setUserProfile(user: profile)
            
            self.isSignedIn = true
            
            print("User \(user.uid) signed in.")
        } catch {
            print("Error signing in: \(error)")
            throw error
        }
    }
    
    @MainActor
    func signUp(name: String, userName: String, email: String, password: String) async throws {
        do {
            let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
            let user = authResult.user
            
            let userProfile = User(userId: user.uid, email: email, name: name, userName: userName)
            try await usersRepository.createUser(newUser: userProfile)
            
            self.setUserProfile(user: userProfile)
            
            self.isSignedIn = true
            
            print("User \(user.uid) signed up.")
        } catch {
            print("Error signing up: \(error)")
            throw error
        }
    }
    
    @MainActor
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.isSignedIn = false
            self.isStarting = false
            self.setUserProfile(user: User(userId: "", name: "", userName: ""))
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    func editProfile(setting: SettingsType, newValue: String) async throws {
        switch setting {
        case .picture:
            try await usersRepository.updateUserInfo(userId: profile.id, newName: nil, newUserName: nil, newDescription: nil, newImageName: newValue)
        case .name:
            try await usersRepository.updateUserInfo(userId: profile.id, newName: newValue, newUserName: nil, newDescription: nil, newImageName: nil)
        case .username:
            try await usersRepository.updateUserInfo(userId: profile.id, newName: nil, newUserName: newValue, newDescription: nil, newImageName: nil)
        case .description:
            try await usersRepository.updateUserInfo(userId: profile.id, newName: nil, newUserName: nil, newDescription: newValue, newImageName: nil)
        }
        
        await self.reloadUser()
    }
}
