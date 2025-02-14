//
//  ProfileUserRoutesList.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 25.08.2024.
//

import Foundation
import SwiftUI

struct ProfileUserRoutesList: View {
    @EnvironmentObject var auth: AuthController
    @EnvironmentObject var globalSettings: GlobalSettings
    @ObservedObject var viewModel: ProfileViewModel
    
    private var currentUser: Bool {
        viewModel.user.id == auth.profile.id
    }
    
    var body: some View {
        if viewModel.routesLoading {
            loader
        } else {
            VStack(spacing: 20) {
                HStack {
                    SectionHeader(
                        headline: .constant("\(currentUser ? "Your" : "\(viewModel.user.name)'s") Routes")
                    )
                    Spacer()
                    
                    if currentUser {
                        unpublishedToggle
                    }
                }
                
                if viewModel.routesLoadingError {
                    WidgetError(text: "user's routes", action: self.loadData)
                } else {
                    if viewModel.routes.count > 0 {
                        ForEach(viewModel.loadUnpublished ? viewModel.routes : viewModel.routes.filter { $0.datePublished != nil }, id: \.id) { route in
                            RouteCard(
                                route: Binding(get: { route }, set: { _ in }),
                                label: route.datePublished == nil ? .unpublished
                                    : route.saves.count > 0 ? .likes(route.saves.count)
                                    : .published(route.datePublished!),
                                size: .M
                            )
                        }
                    } else if currentUser {
                        Button(action: {
                            globalSettings.goToTab(.newRoute)
                        }) {
                            ActionBanner(text: "You haven’t created any routes", actionText: "Create a new route")
                        }
                    } else {
                        noRoutes
                    }
                }
            }
        }
    }
    
    private var unpublishedToggle: some View {
        HStack {
            VStack(alignment: .trailing, spacing: -2) {
                Text("Show")
                Text("unpublished")
                
            }
            .font(.system(size: 15))
            .foregroundColor(Color.black.opacity(0.2))
            .padding(.trailing, -5)
            
            Toggle("", isOn: $viewModel.loadUnpublished)
                .padding(.all, 0)
                .frame(maxWidth: 57)
                .onTapGesture {
                    viewModel.loadUnpublished.toggle()
                }
        }
    }
    
    private var noRoutes: some View {
        VStack(spacing: 10) {
            Text("User has no routes")
                .foregroundColor(Color.black.opacity(0.3))
            
            Image(systemName: "map")
                .icon(size: 50, colour: Color.black.opacity(0.2))
                .fontWeight(.ultraLight)
                .padding()
                .background(Color.black.opacity(0.025))
                .cornerRadius(100)
        }
    }
    
    private var loader: some View {
        VStack(spacing: 20) {
            HStack {
                Color(Color.black.opacity(0.05))
                    .frame(width: 150, height: 24)
                    .loading(isLoading: true)
                Spacer()
            }
            
            ForEach(0..<3) { _ in
                VStack (spacing: 5) {
                    Color(Color.black.opacity(0.05))
                        .frame(height: 165)
                        .loading(isLoading: true)
                    Color(Color.black.opacity(0.05))
                        .frame(height: 20)
                        .loading(isLoading: true)
                    Color(Color.black.opacity(0.05))
                        .frame(height: 40)
                        .loading(isLoading: true)
                }
            }
        }
    }
    
    private func loadData() {
        Task {
            await viewModel.loadUserRoutes(isCurrentUser: currentUser)
        }
    }
}

#Preview {
    ProfileUserRoutesList(viewModel: ProfileViewModel(user: MockData.Users[0]))
        .environmentObject(AuthController(testProfile: false))
        .environmentObject(GlobalSettings())
        .padding()
}
