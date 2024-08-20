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
    @StateObject var viewModel: ProfileViewModel
    @Binding var tabSelection: Int
    
    init(user: User, tabSelection: Binding<Int>) {
        self._viewModel = StateObject(wrappedValue: ProfileViewModel(user: user))
        self._tabSelection = tabSelection
    }
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 25) {
                    Header
                    
                    if let description = viewModel.user.description {
                        Text(description)
                    }
                    
                    UserStatIcons
                    
                    YourRoutes
                }
            }
            .refreshable {
                viewModel.fetchUser()
                viewModel.loadRoutes()
            }
            .scrollClipDisabled()
            .padding(.top, 20)
            .padding(.horizontal, 20)
            .navigationDestination(for: RouteNavigation.self) { value in
                switch value {
                case .info(let route):
                    RouteView(route: route)
                case .progress(let route):
                    OnRouteView(route: route, user: auth.profile, savedRouteProgress: currentRoute.routeProgress)
                case .map(let route):
                    MapRouteView(route: route)
                case .finishedRoute(let finishedRoute):
                    if let route = finishedRoute.route { RouteView(route: route) }
                }
            }            
            .navigationDestination(for: ProfileNavigation.self) { value in
                switch value {
                case .profile(let user):
                    ProfileView(user: user, tabSelection: $tabSelection)
                case .finishedRoutes:
                    FinishedRoutesView()
                case .collectables:
                    ProfileCollectablesView(user: viewModel.user)
                case .awards:
                    AwardsView(user: viewModel.user)
                case .settings:
                    SettingsView()
                }
            }
        }
        .onAppear {
            viewModel.fetchUser()
            viewModel.loadRoutes()
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
                                                    
                    HStack(spacing: 10) {
                        Text(String(viewModel.user.friends.count))
                            .font(.system(size: 20, weight: .bold))
                            .kerning(-0.2)
                        Text("friends")
                    }
                    .frame(height: 45)
                    .frame(maxWidth: .infinity)
                }
            }
        }
    }
    
    private var UserStatIcons: some View {
        HStack(spacing: 10) {
            NavigationLink(value: ProfileNavigation.awards) {
                StatIcon(icon: "Trophy3DIcon", number: viewModel.user.awards.count, word: "awards", colour: Color.redAccent)
            }
            
            NavigationLink(value: ProfileNavigation.finishedRoutes) {
                StatIcon(icon: "Route3DIcon", number: viewModel.user.finishedRoutes.count, word: "routes finished", colour: Color.greenAccent)
            }
            
            NavigationLink(value: ProfileNavigation.collectables) {
                StatIcon(icon: "Treasures3DIcon", number: viewModel.user.collectables.count, word: "collectables", colour: Color.blueAccent)
            }
        }
    }
    
    private func StatIcon(icon: String, number: Int, word: String, colour: Color) -> some View {
        VStack(spacing: 0) {
            Image(icon)
                .resizable()
                .scaledToFit()
                .frame(width: 50)
            
            Text(String(number))
                .font(.system(size: 20, weight: .bold))
            Text(word)
                .font(.system(size: 14, weight: .light))

        }
        .foregroundColor(Color.black)
        .frame(width: (UIScreen.main.bounds.width - 60) / 3, height: (UIScreen.main.bounds.width - 60) / 3)
        .background(colour.opacity(0.2))
        .cornerRadius(8)
    }
    
    private var YourRoutes: some View {
        VStack(spacing: 20) {
            HStack {
                SectionHeader(
                    headline: .constant("Your Routes")
                )
                Spacer()
            }
            
            if viewModel.routes.count > 0 {
                ForEach($viewModel.routes, id: \.id) { route in
                    RouteCard(route: route, size: .M)
                }
            } else {
                Button(action: {
                    tabSelection = 2
                }) {
                    ActionBanner(text: "You haven’t created any routes", actionText: "Create a new route")
                }
            }
        }
    }
}

#Preview {
    ProfileView(user: MockData.Users[0], tabSelection: .constant(4))
        .environmentObject(AuthController(testProfile: true))
        .environmentObject(CurrentRouteManager())
}
