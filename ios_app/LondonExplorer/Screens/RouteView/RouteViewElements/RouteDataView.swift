//
//  RouteDataView.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 20.06.2024.
//

import Foundation
import SwiftUI

struct RouteDataView: View {
    @EnvironmentObject var auth: AuthController
    @EnvironmentObject var currentRoute: CurrentRouteManager
    @EnvironmentObject var awards: AwardsObserver
    @ObservedObject var viewModel: RouteViewModel
    
    var body: some View {
        VStack(spacing: 25) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    if auth.profile.id != viewModel.route.userCreated, let user = viewModel.userCreated {
                        NavigationLink(value: ProfileNavigation.profile(user)) {
                            HStack(spacing: 5) {
                                if let image = user.image {
                                    Image(uiImage: image)
                                        .profilePicture(size: 20)
                                } else {
                                    Image("User3DIcon")
                                        .profilePicture(size: 20)
                                }
                                
                                Text(user.name)
                                    .headline()
                                
                                Text("shared")
                                    .subheadline()
                            }
                            .foregroundColor(Color.black)
                        }
                    }
                    
                    Text(viewModel.route.name)
                        .screenHeadline()
                    
                    RouteLabelRow(route: viewModel.route)
                }
                
                Spacer()
                
                Image("Route3DIcon")
                    .icon(size: 70)
            }
            
            HStack(spacing: 0) {
                FirstButton
                
                SecondButton

                ThirdButton
            }
            
            HStack {
                Text(viewModel.route.description)
                Spacer()
            }
            
            RouteMapContent(route: $viewModel.route)
            
            HStack {
                SectionHeader(headline: .constant("Stops"))
                Spacer()
            }
            
            RouteStopsList(route: $viewModel.route)
        }
    }
    
    private var FirstButton: some View {
        VStack {
            if viewModel.isPublishing {
                RouteButton.publishing.view
            } else if let publishedDate = viewModel.route.datePublished {
                RouteButton.published(publishedDate).view
            } else {
                Button(action: {
                    Task {
                        viewModel.isPublishing = true
                        await viewModel.publishRoute()
                        await awards.getRoutesNumber(user: auth.profile)
                        awards.checkAward(for: .publishedRoute, user: auth.profile)
                        viewModel.isPublishing = false
                    }
                }) {
                    RouteButton.publish.view
                }
                .disabled(auth.profile.id != viewModel.route.userCreated)
            }
        }
        .overlay(
            Rectangle()
                .fill(Color.black)
                .frame(width: 1),
            alignment: .trailing
        )
    }
    
    private var SecondButton: some View {
        VStack {
            if viewModel.isSaving {
                RouteButton.saving.view
            } else if viewModel.route.datePublished != nil {
                if viewModel.route.saves.contains(auth.profile.id) {
                    Button(action: {
                        Task {
                            viewModel.isSaving = true
                            await viewModel.dislikeRoute(user: auth.profile)
                            viewModel.isSaving = false
                        }
                    }) {
                        RouteButton.saved(viewModel.route.saves.count).view
                    }
                } else {
                    Button(action: {
                        Task {
                            viewModel.isSaving = true
                            await viewModel.saveRoute(user: auth.profile)
                            viewModel.isSaving = false
                        }
                    }) {
                        RouteButton.save(viewModel.route.saves.count).view
                    }
                }
            } else {
                Button(action: {
                    viewModel.isEditSheetPresented = true
                }) {
                    RouteButton.edit.view
                }
                .disabled(auth.profile.id != viewModel.route.userCreated)
            }
        }
        .overlay(
            Rectangle()
                .frame(width: 1),
            alignment: .trailing
        )
        .sheet(isPresented: $viewModel.isEditSheetPresented) {
            EditRouteView(viewModel: viewModel)
        }
    }
    
    private var ThirdButton: some View {
        NavigationLink(value: RouteNavigation.progress(viewModel.route, auth.profile, currentRoute.routeProgress)) {
            if let currentRoute = currentRoute.routeProgress, currentRoute.route.id == viewModel.route.id {
                RouteButton.current.view
            } else if let finishedRoute = auth.profile.finishedRoutes.first(where: { $0.routeId == viewModel.route.id }) {
                RouteButton.completed(finishedRoute.finishedDate).view
            } else {
                RouteButton.start.view
            }
        }
    }
}

#Preview {
    ScrollView(showsIndicators: false) {
        RouteDataView(viewModel: RouteViewModel(route: MockData.Routes[0]))
    }
    .environmentObject(AuthController())
    .environmentObject(CurrentRouteManager())
    .environmentObject(AwardsObserver())
    .padding()
}
