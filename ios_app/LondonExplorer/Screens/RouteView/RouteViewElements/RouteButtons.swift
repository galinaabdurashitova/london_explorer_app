//
//  RouteButtons.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 29.08.2024.
//

import Foundation
import SwiftUI

struct RouteButtons: View {
    @EnvironmentObject var auth: AuthController
    @EnvironmentObject var currentRoute: CurrentRouteManager
    @EnvironmentObject var globalSettings: GlobalSettings
    @EnvironmentObject var awards: AwardsObserver
    @ObservedObject var viewModel: RouteViewModel
    
    var body: some View {
        HStack(spacing: 0) {
            FirstButton
            
            SecondButton

            ThirdButton
        }
    }
    
    private var FirstButton: some View {
        VStack {
            if viewModel.isPublishing {
                RouteButton.publishing.view
            } else if let publishedDate = viewModel.route.datePublished {
                RouteButton.published(publishedDate).view
            } else {
                Button(action: self.publishRoute) {
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
                    Button(action: self.dislikeRoute) {
                        RouteButton.saved(viewModel.route.saves.count).view
                    }
                } else {
                    Button(action: self.likeRoute) {
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
    
    private func publishRoute() {
        Task {
            viewModel.isPublishing = true
            await viewModel.publishRoute()
            globalSettings.profileReloadTrigger = true
            await awards.getRoutesAwards(user: auth.profile)
            awards.checkAward(for: .publishedRoute, user: auth.profile)
            viewModel.isPublishing = false
        }
    }
    
    private func likeRoute() {
        Task {
            viewModel.isSaving = true
            await viewModel.saveRoute(user: auth.profile)
            globalSettings.favouriteRoutesReloadTrigger = true
            viewModel.isSaving = false
        }
    }
    
    private func dislikeRoute() {
        Task {
            viewModel.isSaving = true
            await viewModel.dislikeRoute(user: auth.profile)
            globalSettings.favouriteRoutesReloadTrigger = true
            viewModel.isSaving = false
        }
    }
}

#Preview {
    RouteButtons(viewModel: RouteViewModel(route: MockData.Routes[0]))
        .environmentObject(AuthController())
        .environmentObject(GlobalSettings())
        .environmentObject(AwardsObserver())
        .environmentObject(CurrentRouteManager())
        .padding()
}
