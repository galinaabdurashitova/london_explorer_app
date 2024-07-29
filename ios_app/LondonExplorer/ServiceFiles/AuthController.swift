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
    
    init(testProfile: Bool = false) {
        if testProfile == true  {
            self.setUserProfile()
        } else {
            observeAuthChanges()
        }
    }
    
    private func setUserProfile(user: User = MockData.Users[0]) {
        DispatchQueue.main.async {
            self.profile = user
            self.isSignedIn = true
        }
    }
    
    private func observeAuthChanges() {
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            guard let user = user else { return }
            guard let self = self else { return }

            Task {
                do {
                    let profile = try await self.usersRepository.fetchUser(userId: user.uid)
                    self.setUserProfile(user: profile)
                    print("User \(user.uid) signed in.")
                } catch {
                    print("Error while fetching the user profile: \(error)")
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
            
            let userProfile = User(userId: user.uid/*, email: email*/, name: name, userName: userName)
            try await usersRepository.createUser(newUser: userProfile)
            
            self.setUserProfile(user: userProfile)
            
            print("User \(user.uid) signed up.")
        } catch {
            print("Error signing up: \(error)")
            throw error
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            
            self.setUserProfile(user: User(userId: "", name: "", userName: ""))
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}
