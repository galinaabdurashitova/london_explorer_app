//
//  ProfileView.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 20.06.2024.
//

import Foundation
import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var auth: AuthController
    @EnvironmentObject var currentRoute: CurrentRouteManager
    @EnvironmentObject var globalSettings: GlobalSettings
    @EnvironmentObject var awards: AwardsObserver
    @StateObject var viewModel: ProfileViewModel
    
    init(user: User, loadUnpublished: Bool = false) {
        self._viewModel = StateObject(wrappedValue: ProfileViewModel(user: user, loadUnpublished: loadUnpublished))
    }
    
    var body: some View {
        ZStack {
            if viewModel.userLoadingError {
                ErrorScreen() {
                   viewModel.loadData()
                }
            } else {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 25) {
                        ProfileHeader(viewModel: viewModel)
                        
                        if let description = viewModel.user.description, !viewModel.userLoading {
                            Text(description)
                        }
                        
                        ProfileStatIcons(viewModel: viewModel)
                        
                        ProfileUserRoutesList(viewModel: viewModel)
                    }
                }
                .refreshable {
                    viewModel.loadData(isCurrentUser: viewModel.user == auth.profile)
                    awards.setMaxLikes(likes: viewModel.routes.compactMap { $0.saves.count }.max())
                }
            }
        }
        .scrollClipDisabled()
        .padding(.top, 20)
        .padding(.horizontal)
        .error(text: viewModel.error, isPresented: $viewModel.showError)
        .onAppear {
            if viewModel.user == auth.profile {
                if globalSettings.profileReloadTrigger {
                    viewModel.loadData(isCurrentUser: viewModel.user == auth.profile)
                    globalSettings.profileReloadTrigger = false
                }
                awards.setMaxLikes(likes: viewModel.routes.compactMap { $0.saves.count }.max())
            } else if viewModel.user != auth.profile && !viewModel.firstLoaded {
                viewModel.loadData(isCurrentUser: viewModel.user == auth.profile)
                if !viewModel.user.friends.contains(auth.profile.id)
                    && viewModel.user.id != auth.profile.id {
                    viewModel.getUserFriendRequests(currentUserId: auth.profile.id)
                }
                viewModel.firstLoaded = true
            }
        }
    }
}

#Preview {
    ProfileView(user: MockData.Users[0])
        .environmentObject(AuthController(testProfile: false))
        .environmentObject(CurrentRouteManager())
        .environmentObject(GlobalSettings())
        .environmentObject(AwardsObserver())
}
