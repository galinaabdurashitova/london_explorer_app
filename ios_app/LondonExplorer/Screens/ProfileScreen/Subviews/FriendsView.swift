//
//  FriendsView.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 21.08.2024.
//

import Foundation
import SwiftUI

struct FriendsView: View {
    @EnvironmentObject var auth: AuthController
    @State var user: User
    @State var friends: [User] = []
    @State var isLoadingFriends: Bool = false
    @State var friendsError: Bool = false
    
    private var currentUser: Bool {
        user.id == auth.profile.id
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .center, spacing: 25) {
                HStack {
                    ScreenHeader(
                        headline: .constant("\(currentUser ? "Your" : "\(user.name)'s") friends"),
                        subheadline:  .constant("\(currentUser ? "You have" : "\(user.name) has")  \(friends.count) friends")
                    )
                    
                    Spacer()
                }
                
                VStack(alignment: .leading, spacing: 20) {
                    if isLoadingFriends {
                        loader
                    } else if friendsError {
                        ErrorScreen(action: self.fetchUserFriends)
                    } else {
                        ForEach(friends) { user in
                            NavigationLink(value: ProfileNavigation.profile(user)) {
                                userCard(friend: user)
                            }
                        }
                    }
                }
            }
        }
        .padding(.horizontal)
        .onAppear(perform: self.fetchUserFriends)
    }
    
    private func userCard(friend: User) -> some View {
        HStack {
            LoadingUserImage(userImage: Binding(get: { friend.imageName }, set: { _ in }), imageSize: 70)
            
            VStack(alignment: .leading, spacing: 0) {
                Text(friend.name)
                    .sectionCaption()
                Text("@\(friend.userName)")
                    .sectionSubCaption()
            }
            .foregroundColor(Color.black)
            
            Spacer()
        }
    }
    
    private var loader: some View {
        VStack {
            ForEach(0..<5) { _ in
                HStack {
                    Color(Color.black.opacity(0.05))
                        .frame(width: 70, height: 70)
                        .loading(isLoading: true)
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Color(Color.black.opacity(0.05))
                            .frame(width: 150, height: 24)
                            .loading(isLoading: true)
                        
                        Color(Color.black.opacity(0.05))
                            .frame(width: 100, height: 16)
                            .loading(isLoading: true)
                    }
                    
                    Spacer()
                }
                .padding(.vertical, 10)
            }
        }
    }
    
    private func fetchUserFriends() {
        self.friendsError = false
        if !user.friends.isEmpty {
            self.isLoadingFriends = true
            
            Task {
                do {
                    self.friends = try await UsersService().fetchUsers(userIds: user.friends)
                } catch {
                    print("Unable to catch user's friends")
                    self.friendsError = true
                }
                
                self.isLoadingFriends = false
            }
        }
    }
}

#Preview {
    FriendsView(user: MockData.Users[0])
        .environmentObject(AuthController(testProfile: true))
}
