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
                    Task { await viewModel.loadData() }
                }
            } else {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 25) {
                        Header
                        
                        if let description = viewModel.user.description {
                            Text(description)
                        }
                        
                        UserStatIcons
                        
                        ProfileUserRoutesList(viewModel: viewModel)
                    }
                }
//                .refreshable {
//                    await viewModel.loadData(isCurrentUser: viewModel.user == auth.profile)
//                }
            }
        }
        .scrollClipDisabled()
        .padding(.top, 20)
        .padding(.horizontal)
        .error(text: viewModel.error, isPresented: $viewModel.showError)
        .task {
            await viewModel.loadData(isCurrentUser: viewModel.user == auth.profile)
            if !viewModel.user.friends.contains(auth.profile.id) && viewModel.user.id != auth.profile.id {
                viewModel.getUserFriendRequests(currentUserId: auth.profile.id)
            } //else if viewModel.user.id == auth.profile.id {
//                await awards.getRoutesNumber(user: auth.profile)
//            }
        }
    }
    
    private var Header: some View {
        HStack(spacing: 15) {
            if let image = viewModel.user.image {
                Image(uiImage: image)
                    .profilePicture(size: 120)
            } else {
                Image("User3DIcon")
                    .profilePicture(size: 120)
            }
            
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    VStack(alignment: .leading, spacing: 0) {
                        Text(viewModel.user.name)
                            .screenHeadline()
                        Text("@\(viewModel.user.userName)")
                            .subheadline()
                    }
                    
                    Spacer()
                    
                    if viewModel.user == auth.profile {
                        NavigationLink(value: ProfileNavigation.settings) {
                            Image(systemName: "gearshape")
                                .icon(size: 30, colour: Color.black.opacity(0.3))
                        }
                    } else {
                        FriendButton(viewModel: viewModel)
                    }
                }
                
                
                HStack(spacing: 0) {
                    HStack(spacing: 10) {
                        Text(String(viewModel.routes.count))
                            .font(.system(size: 20, weight: .bold))
                            .kerning(-0.2)
                        Text("routes")
                    }
                    .frame(height: 45)
                    .frame(maxWidth: .infinity)
                    .overlay(
                        Rectangle()
                            .frame(width: 1),
                        alignment: .trailing
                    )
                    
                    NavigationLink(value: ProfileNavigation.friends(viewModel.user)) {
                        HStack(spacing: 10) {
                            Text(String(viewModel.user.friends.count))
                                .font(.system(size: 20, weight: .bold))
                                .kerning(-0.2)
                            Text("friends")
                        }
                        .foregroundColor(Color.black)
                        .frame(height: 45)
                        .frame(maxWidth: .infinity)
                    }
                }
            }
        }
    }
    
    private var UserStatIcons: some View {
        HStack(spacing: 10) {
            NavigationLink(value: ProfileNavigation.awards(viewModel.user)) {
                ProfileStatIcon(icon: "Trophy3DIcon", number: Binding(get: { viewModel.user.awards.count }, set: { _ in }), word: "awards", colour: Color.redAccent)
            }
            
            NavigationLink(value: ProfileNavigation.finishedRoutes(viewModel.user)) {
                ProfileStatIcon(icon: "Route3DIcon", number: Binding(get: { viewModel.user.finishedRoutes.count }, set: { _ in }), word: "routes finished", colour: Color.greenAccent)
            }
            
            NavigationLink(value: ProfileNavigation.collectables(viewModel.user)) {
                ProfileStatIcon(icon: "Treasures3DIcon", number: Binding(get: { viewModel.user.collectables.count }, set: { _ in }), word: "collectables", colour: Color.blueAccent)
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
