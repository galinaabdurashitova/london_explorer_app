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
    
    private var currentUser: Bool {
        viewModel.user == auth.profile
    }
    
    init(user: User, isMyProfile: Bool = false) {
        self._viewModel = StateObject(wrappedValue: ProfileViewModel(user: user, isMyProfile: isMyProfile))
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
                .refreshable { self.refreshData() }
            }
        }
        .scrollClipDisabled()
        .padding(.top, 20)
        .padding(.horizontal)
        .error(text: viewModel.error, isPresented: $viewModel.showError)
        .onAppear {
            self.loadScreen()
        }
    }
    
    private func loadScreen() {
        if viewModel.isMyProfile && globalSettings.profileReloadTrigger {
            self.refreshData()
            globalSettings.setProfileReloadTrigger(to: false)
        } else if !viewModel.firstLoaded {
            self.refreshData()
        }
        viewModel.setScreenLoad(to: true)
    }
    
    private func refreshData() {
        viewModel.loadData(isCurrentUser: currentUser)
        if currentUser {
            awards.setMaxLikes(likes: viewModel.routes.compactMap { $0.saves.count }.max())
        } else if !viewModel.user.friends.contains(auth.profile.id) {
            viewModel.getUserFriendRequests(currentUserId: auth.profile.id)
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
