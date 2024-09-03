//
//  OnRouteView.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 11.07.2024.
//

import Foundation
import SwiftUI
import MapKit

struct OnRouteView: View {
    @EnvironmentObject var auth: AuthController
    @EnvironmentObject var currentRoute: CurrentRouteManager
    @EnvironmentObject var globalSettings: GlobalSettings
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: OnRouteViewModel
    
    init(route: Route, user: User, savedRouteProgress: RouteProgress?) {
        self._viewModel = StateObject(wrappedValue: OnRouteViewModel(route: route, user: user, savedRouteProgress: savedRouteProgress))
    }
    
    init(routeProgress: RouteProgress) {
        self._viewModel = StateObject(wrappedValue: OnRouteViewModel(routeProgress: routeProgress))
    }
    
    var body: some View {
        ZStack {
            if viewModel.isMapLoading {
                ProgressView()
            } else {
                ZStack (alignment: .topLeading) {
                    OnRouteMap(viewModel: viewModel)
                    
                    BackButton() {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                    .padding(.leading)
                    
                    OnRouteStatWindow(viewModel: viewModel)
                }
            }
        }
        .toolbar(.hidden, for: .tabBar)
        .navigationBarBackButtonHidden(true)
        .error(text: viewModel.error, isPresented: $viewModel.showError)
        .overlay {
            overlays
        }
        .popup(
            isPresented: $viewModel.stopRoute,
            text: "Are you sure you want to stop the route? Your progress won't be saved",
            buttonText: "Stop the route",
            action: self.stopRoute
        )
    }
    
    private var overlays: some View {
        ZStack {
            if viewModel.showGreeting {
                StartRouteGreeting(
                    text: viewModel.greetingText,
                    subText: viewModel.greetingSubText
                ) {
                    self.closeGreeting()
                } actionCancel: {
                    self.presentationMode.wrappedValue.dismiss()
                }
            } else if viewModel.lastStop {
                FinishRoutePopup(
                    isOpen: $viewModel.lastStop,
                    isLoading: $viewModel.isFinishing,
                    awards: viewModel.awarded
                ) {
                    self.finishRoute()
                }
            } else if let collectedItem = viewModel.collected {
                CollectedCollectableView(
                    collectable: collectedItem.type,
                    alreadyHave: self.alreadyHaveCollectable(collectedItem)
                ) {
                    self.collectCollectable()
                }
            }
        }
    }
    
    private func closeGreeting() {
        currentRoute.routeProgress = viewModel.routeProgress
        viewModel.setGreeting(to: false)
    }
    
    private func collectCollectable() {
        viewModel.collectCollectable()
        currentRoute.routeProgress = viewModel.routeProgress
    }
    
    private func alreadyHaveCollectable(_ collectable: Route.RouteCollectable) -> Bool {
        auth.profile.collectables.compactMap{ $0.type }.contains(collectable.type) || viewModel.routeProgress.collectables.contains(collectable)
    }
    
    private func finishRoute() {
        viewModel.setFinishing(to: true)
        Task {
            await viewModel.finishRoute(userId: auth.profile.id)
            await auth.reloadUser()
            globalSettings.setProfileReloadTrigger(to: true)
            self.stopRoute()
            viewModel.setFinishing(to: false)
        }
    }
    
    private func stopRoute() {
        currentRoute.routeProgress = nil
        self.presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    OnRouteView(routeProgress: MockData.RouteProgress[0])
        .environmentObject(AuthController())
        .environmentObject(CurrentRouteManager())
        .environmentObject(GlobalSettings())
}
