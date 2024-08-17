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
    @Published var isStarting = false
    @Published var profile: User = User(userId: "", name: "", userName: "")
    
    private var usersRepository: UsersServiceProtocol = UsersService()
    private var routesRepository: RoutesServiceProtocol = RoutesService()
    
    init(testProfile: Bool = false) {
        if testProfile == true  {
            self.setUserProfile()
        } else {
            isStarting = true
            observeAuthChanges()
            isStarting = false
        }
    }
    
    func reloadUser() {
        DispatchQueue.main.async {
            Task {
                do {
                    self.profile = try await self.usersRepository.fetchUser(userId: self.profile.id)
                    await self.getFinishedRoutes()
                } catch {
                    print("Error while fetching the user profile: \(error)")
                }
            }
        }
    }
    
    func getFinishedRoutes() async {
        print("Start loading finished routes")
        for routeIndex in self.profile.finishedRoutes.indices {
            print("Finished route \(routeIndex)")
            do {
                let route = try await self.routesRepository.fetchRoute(routeId: self.profile.finishedRoutes[routeIndex].routeId)
                print("Route fetched:")
                print("Route name: \(route.name)")
                print("Stops count: \(route.stops.count)")
                print("Time: \(route.routeTime)")
                
                DispatchQueue.main.async {
                    self.profile.finishedRoutes[routeIndex].route = route
                    print("Now route saved:")
                    print("Route name: \(self.profile.finishedRoutes[routeIndex].route?.name)")
                    print("Stops count: \(self.profile.finishedRoutes[routeIndex].route?.stops.count)")
                    print("Time: \(self.profile.finishedRoutes[routeIndex].route?.routeTime)")
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
            self.isSignedIn = true
            
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
            self.isSignedIn = true
            
            print("User \(user.uid) signed up.")
        } catch {
            print("Error signing up: \(error)")
            throw error
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            
            DispatchQueue.main.async {
                self.isSignedIn = false
                self.setUserProfile(user: User(userId: "", name: "", userName: ""))
            }
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}
