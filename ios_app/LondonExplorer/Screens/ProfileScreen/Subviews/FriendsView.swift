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
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .center, spacing: 25) {
                HStack {
                    let username = user.id == auth.profile.id
                    
                    ScreenHeader(
                        headline: .constant("\(username ? "Your" : "\(user.name)'s") friends"),
                        subheadline:  .constant("\(username ? "You have" : "\(user.name) has")  \(friends.count) friends")
                    )
                    
                    Spacer()
                }
                
                VStack(alignment: .leading, spacing: 20) {
                    ForEach(friends) { user in
                        NavigationLink(value: ProfileNavigation.profile(user)) {
                            HStack {
                                if let image = user.image {
                                    Image(uiImage: image)
                                        .profilePicture(size: 70)
                                } else {
                                    Image("User3DIcon")
                                        .profilePicture(size: 70)
                                }
                                
                                VStack(alignment: .leading, spacing: 0) {
                                    Text(user.name)
                                        .sectionCaption()
                                    Text("@\(user.userName)")
                                        .sectionSubCaption()
                                }
                                .foregroundColor(Color.black)
                                
                                Spacer()
                            }
                        }
                    }
                }
            }
        }
        .padding(.horizontal)
        .task {
            if !user.friends.isEmpty {
                do {
                    self.friends = try await UsersService().fetchUsers(userIds: user.friends)
                } catch {
                    print("Unable to catch user's friends")
                }
            }
        }
    }
}

#Preview {
    FriendsView(user: MockData.Users[0])
        .environmentObject(AuthController(testProfile: true))
}
