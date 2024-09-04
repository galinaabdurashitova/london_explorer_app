//
//  AuthView.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 23.07.2024.
//

import Foundation
import SwiftUI

struct AuthView: View {
    @EnvironmentObject var auth: AuthController
    @State var newUser: Bool = false
    @State var userName: String = ""
    @State var name: String = ""
    @State var userEmail: String = ""
    @State var password: String = ""
    @State var errorMessage: String?
    @State var isLoading: Bool = false
    
    var body: some View {
        VStack(spacing: 25) {
            HStack {
                LondonExplorerLogo(scrollOffset: 50)
                Image("Bus3DIcon")
                    .onTapGesture(count: 4) {
                        Server.localServer.toggle()
                    }
            }
            
            if let error = errorMessage {
                Text(error)
                    .foregroundColor(Color.redAccent)
            }
            
            if auth.isStarting {
                ProgressView()
                    .progressViewStyle(.circular)
            } else {
                if newUser {
                    CustomTextField(fieldText: .constant("Username"), fillerText: .constant("Create your unique username"), textVariable: $userName, maxLength: 16)
                    
                    CustomTextField(fieldText: .constant("Name"), fillerText: .constant("Enter your first name"), textVariable: $name, maxLength: 64)
                }
                
                CustomTextField(fieldText: .constant("Email"), fillerText: .constant("Enter your email"), textVariable: $userEmail, maxLength: 64)
                
                CustomTextField(fieldText: .constant("Password"), fillerText: .constant(newUser ? "Set up your password" : "Enter your password"), textVariable: $password, isSecure: true, maxLength: 64)
                
                ButtonView(
                    text: .constant(newUser ? "Sign up" : "Log In"),
                    colour: Color.blueAccent,
                    textColour: Color.white,
                    size: .L,
                    disabled: Binding<Bool> (
                        get: { (newUser && userName.isEmpty) || (newUser && name.isEmpty) || userEmail.isEmpty || password.isEmpty },
                        set: { _ in }
                    ),
                    isLoading: $isLoading,
                    action: self.authorise
                )
                
                Button(action: {
                    newUser.toggle()
                }) {
                    Text(newUser ? "Log In" : "Sign up")
                        .foregroundColor(Color.blueAccent)
                }
            }
        }
        .padding()
    }
    
    private func authorise() {
        self.isLoading = true
        
        Task {
            do {
                if newUser {
                    try await auth.signUp(name: name, userName: userName, email: userEmail, password: password)
                } else {
                    try await auth.login(email: userEmail, password: password)
                }
            } catch {
                self.errorMessage = error.localizedDescription
            }
            self.isLoading = false
        }
    }
}

#Preview {
    AuthView()
        .environmentObject(AuthController())
}
