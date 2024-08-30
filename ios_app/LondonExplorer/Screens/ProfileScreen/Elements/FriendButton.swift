//
//  FriendButton.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 21.08.2024.
//

import Foundation
import SwiftUI

struct FriendButton: View {
    enum Stage: String {
        case friends = "Friends"
        case requested = "Requested"
        case add = "Add friend"
        
        var iconName: String {
            switch self {
            case .friends:      return "person.2.fill"
            case .requested:    return "checkmark"
            case .add:          return "person.badge.plus"
            }
        }
        
        var color: Color {
            switch self {
            case .friends:      return Color.blueAccent
            case .requested:    return Color.greenAccent
            case .add:          return Color.black.opacity(0.16)
            }
        }
    }
    
    @EnvironmentObject var auth: AuthController
    @EnvironmentObject var awards: AwardsObserver
    @EnvironmentObject var globalSettings: GlobalSettings
    @ObservedObject var viewModel: ProfileViewModel
    
    var body: some View {
        ZStack {
            if viewModel.user.friends.contains(auth.profile.id) {
                button(type: .friends)
            } else if viewModel.isUserRequestProcessing {
                ProgressView()
            } else if viewModel.isFriendRequestSent {
                button(type: .requested)
            } else {
                Button(action: self.addFriend) {
                    button(type: .add)
                }
            }
        }
    }
    
    private func button(type: Stage) -> some View {
        HStack {
            Text(type.rawValue)
                .foregroundColor(Color.white)
                .font(.system(size: 13))
            Image(systemName: type.iconName)
                .icon(size: 20, colour: Color.white)
        }
        .padding(.all, 5)
        .background(type.color)
        .cornerRadius(8)
    }
    
    private func addFriend() {
        Task {
            await viewModel.addFriend(userFromId: auth.profile.id)
            await auth.reloadUser()
            awards.checkAward(for: .friendshipApproved, user: auth.profile)
            globalSettings.setProfileReloadTrigger(to: true)
        }
    }
}

#Preview {
    FriendButton(viewModel: ProfileViewModel(user: MockData.Users[0]))
        .environmentObject(AuthController(testProfile: false))
        .environmentObject(AwardsObserver())
        .environmentObject(GlobalSettings())
}
