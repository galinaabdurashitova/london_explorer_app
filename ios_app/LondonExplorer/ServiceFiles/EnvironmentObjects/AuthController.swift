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
            print(1)
            observeAuthChanges()
            print(2)
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
        print(self.profile.awards)
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
                    self.isStarting = false
                }
            }
        }
    }
    
    
    func login(email: String, password: String) async throws {
        do {
            let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
            let user = authResult.user
            
            let profile = try await usersRepository.fetchUser(userId: user.uid)
            
            self.setUserProfile(user: profile)
            
            DispatchQueue.main.async {
                self.isSignedIn = true
            }
            
            print("User \(user.uid) signed in.")
        } catch {
            print("Error signing in: \(error)")
            throw error
        }
    }
    
    func signUp(name: String, userName: String, email: String, password: String) async throws {
        do {
            let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
            let user = authResult.user
            
            let userProfile = User(userId: user.uid, email: email, name: name, userName: userName)
            try await usersRepository.createUser(newUser: userProfile)
            
            self.setUserProfile(user: userProfile)
            
            DispatchQueue.main.async {
                self.isSignedIn = true
            }
            
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
}
