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
    
    private var currentUser: Bool {
        auth.profile.id == viewModel.route.userCreated
    }
    
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
                .disabled(!self.currentUser)
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
                        self.saveRoute(false)
                    }) {
                        RouteButton.saved(viewModel.route.saves.count).view
                    }
                } else {
                    Button(action: {
                        self.saveRoute(true)
                    }) {
                        RouteButton.save(viewModel.route.saves.count).view
                    }
                }
            } else {
                Button(action: {
                    viewModel.setShowEditSheet(to: true)
                }) {
                    RouteButton.edit.view
                }
                .disabled(!self.currentUser)
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
            viewModel.setIsPublishing(to: true)
            await viewModel.publishRoute()
            await awards.getRoutesAwards(user: auth.profile)
            awards.checkAward(for: .publishedRoute, user: auth.profile)
            globalSettings.setProfileReloadTrigger(to: true)
            viewModel.setIsPublishing(to: false)
        }
    }
    
    private func saveRoute(_ save: Bool) {
        Task {
            viewModel.setIsSaving(to: true)
            if save {
                await viewModel.saveRoute(user: auth.profile)
            } else {
                await viewModel.dislikeRoute(user: auth.profile)
            }
            globalSettings.setFavouriteRoutesReloadTrigger(to: true)
            viewModel.setIsSaving(to: false)
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
