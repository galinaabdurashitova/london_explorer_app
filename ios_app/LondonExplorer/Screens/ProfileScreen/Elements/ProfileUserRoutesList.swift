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
    
    var body: some View {
        if viewModel.routesLoading {
            loader
        } else {
            let username = viewModel.user.id == auth.profile.id
            
            VStack(spacing: 20) {
                HStack {
                    SectionHeader(
                        headline: .constant("\(username ? "Your" : "\(viewModel.user.name)'s") Routes")
                    )
                    Spacer()
                    
                    if username {
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
                
                if viewModel.routesLoadingError {
                    WidgetError(text: "user's routes") {
                        Task {
                            await viewModel.loadUserRoutes(isCurrentUser: auth.profile.id == viewModel.user.id)
                        }
                    }
                } else {
                    if viewModel.routes.count > 0 {
                        ForEach(viewModel.loadUnpublished ? viewModel.routes : viewModel.routes.filter { $0.datePublished != nil }, id: \.id) { route in
                            RouteCard(route: Binding(get: { route }, set: { _ in }), size: .M)
                        }
                    } else if username {
                        Button(action: {
                            globalSettings.tabSelection = 2
                        }) {
                            ActionBanner(text: "You haven’t created any routes", actionText: "Create a new route")
                        }
                    } else {
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
                }
            }
        }
    }
    
    private var noRoutes: some View {
        VStack {
            
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
}

#Preview {
    ProfileUserRoutesList(viewModel: ProfileViewModel(user: MockData.Users[0]))
        .environmentObject(AuthController(testProfile: false))
        .environmentObject(GlobalSettings())
        .padding()
}
