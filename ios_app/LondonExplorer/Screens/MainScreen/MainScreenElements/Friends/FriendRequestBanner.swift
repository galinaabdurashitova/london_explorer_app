//
//  FriendRequestBanner.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 21.08.2024.
//

import Foundation
import SwiftUI

struct FriendRequestBanner: View {
    @EnvironmentObject var auth: AuthController
    @EnvironmentObject var awards: AwardsObserver
    @EnvironmentObject var globalSettings: GlobalSettings
    @ObservedObject var viewModel: FriendsFeedViewModel
    @Binding var user: User
    
    var body: some View {
        HStack {
            NavigationLink(value: ProfileNavigation.profile(user)) {
                if let image = user.image {
                    Image(uiImage: image)
                        .profilePicture(size: 50)
                } else {
                    Image("User3DIcon")
                        .profilePicture(size: 50)
                }
                VStack (alignment: .leading, spacing: 2) {
                    Text("You have a friend request")
                        .font(.system(size: 12, weight: .semibold))
                        .opacity(0.5)
                    Text(user.name)
                        .headline()
                    Text(user.userName)
                        .subheadline()
                }
            }
            Spacer()
            
            Button(action: {
                Task {
                    await viewModel.acceptRequest(currentUserId: auth.profile.id, userFromId: user.id)
                    await auth.reloadUser()
                    awards.checkAward(for: .friendshipApproved, user: auth.profile)
                    globalSettings.profileReloadTrigger = true
                }
            }) {
                Image(systemName: "checkmark")
                    .icon(size: 20, colour: Color.greenAccent)
                    .fontWeight(.semibold)
                    .padding(.all, 10)
                    .background(Color.white.opacity(0.5))
                    .cornerRadius(100)
            }
            
            Button(action: {
                viewModel.declineRequest(currentUserId: auth.profile.id, userFromId: user.id)
            }) {
                Image(systemName: "xmark")
                    .icon(size: 20, colour: Color.redAccent)
                    .fontWeight(.semibold)
                    .padding(.all, 10)
                    .background(Color.white.opacity(0.5))
                    .cornerRadius(100)
            }
        }
        .padding(.all, 15.0)
        .foregroundColor(Color.black)
        .background(Color.lightBlue)
        .cornerRadius(8)
    }
}

#Preview {
    FriendRequestBanner(viewModel: FriendsFeedViewModel(), user: .constant(MockData.Users[0]))
        .environmentObject(AuthController())
        .environmentObject(AwardsObserver())
        .environmentObject(GlobalSettings())
        .padding()
}
