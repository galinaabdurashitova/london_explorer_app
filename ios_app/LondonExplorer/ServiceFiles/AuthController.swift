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
    @Published var profile: User = User(userId: "", name: "", userName: "")
    
    private var usersRepository: UsersServiceProtocol = UsersService()
    
    init(testProfile: Bool? = false) {
        if let test = testProfile, test == true  {
            DispatchQueue.main.async {
                self.profile = MockData.Users[0]
                self.isSignedIn = true
            }
        } else {
            observeAuthChanges()
        }
    }
    
    private func fetchUserProfile(userId: String) async {
        do {
            let profile = try await usersRepository.fetchUser(userId: userId)
            DispatchQueue.main.async {
                self.profile = profile
                self.isSignedIn = true
            }
        } catch {
            print("Error while fetching the user profile: \(error)")
        }
    }
    
    private func observeAuthChanges() {
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async {
                self?.isSignedIn = user != nil
                
                guard let user = user else { return }
                print("User \(user.uid) signed in.")

                Task {
                    await self?.fetchUserProfile(userId: user.uid)
                }
            }
        }
    }
    
    func login(email: String, password: String) async throws {
        do {
            let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
            let user = authResult.user
            print("User \(user.uid) signed in.")
            
            await fetchUserProfile(userId: user.uid)
        } catch {
            print("Error signing in: \(error)")
            throw error
        }
    }
    
    func signUp(name: String, userName: String, email: String, password: String) async throws {
        do {
            let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
            let user = authResult.user
            print("User \(user.uid) signed up.")
            
            let userProfile = User(userId: user.uid/*, email: email*/, name: name, userName: userName)
            
            // Replace with actual async profile creation implementation
            do {
                try await usersRepository.createUser(newUser: userProfile)
                
                DispatchQueue.main.async {
                    self.profile = userProfile
                    self.isSignedIn = true
                }
            } catch {
                throw NSError(domain: "AuthController", code: 999, userInfo: [NSLocalizedDescriptionKey: "Unexpected error"])
            }
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
                self.profile = User(userId: "", name: "", userName: "")
            }
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}
