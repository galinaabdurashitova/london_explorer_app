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
                
                if viewModel.showGreeting {
                    Color.white.opacity(0.1)
                        .edgesIgnoringSafeArea(.all)
                        .background(.ultraThinMaterial)
                    
                    StartRouteGreeting(
                        text: viewModel.greetingText,
                        subText: viewModel.greetingSubText
                    ) {
                        currentRoute.routeProgress = viewModel.routeProgress
                        viewModel.showGreeting = false
                    } actionCancel: {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
        .toolbar(.hidden, for: .tabBar)
        .navigationBarBackButtonHidden(true)
        .error(text: viewModel.error, isPresented: $viewModel.showError)
        .toolbar(.hidden, for: .tabBar)
        .overlay {
            if viewModel.lastStop {
                FinishRoutePopup(isOpen: $viewModel.lastStop, awards: viewModel.awarded) {
                    Task {
                        do {
                            try viewModel.finishRoute(userId: auth.profile.id)
                            await auth.reloadUser()
                            currentRoute.routeProgress = nil
                            globalSettings.profileReloadTrigger = true
                            self.presentationMode.wrappedValue.dismiss()
                        } catch {
                            viewModel.showError = true
                            viewModel.error = error.localizedDescription
                            viewModel.showError = true
                        }
                    }
                }
            } else if let collectedItem = viewModel.collected {
                CollectedCollectableView(
                    collectable: collectedItem.type,
                    alreadyHave: auth.profile.collectables.compactMap{ $0.type }.contains(collectedItem.type) || viewModel.routeProgress.collectables.contains(collectedItem)
                ) {
                    viewModel.collectCollectable()
                    currentRoute.routeProgress = viewModel.routeProgress
                }
            }
        }
        .popup(
            isPresented: $viewModel.stopRoute,
            text: "Are you sure you want to stop the route? Your progress won't be saved",
            buttonText: "Stop the route"
        ) {
            currentRoute.routeProgress = nil
            self.presentationMode.wrappedValue.dismiss()
        }
        .sheet(isPresented: Binding<Bool>( get: { !viewModel.error.isEmpty }, set: { _ in })) {
            VStack {
                Text("Error saving progress: \(viewModel.error)")
                    .foregroundColor(Color.redAccent)
            }
        }
    }
}

#Preview {
    OnRouteView(routeProgress: MockData.RouteProgress[0])
        .environmentObject(AuthController())
        .environmentObject(CurrentRouteManager())
        .environmentObject(GlobalSettings())
}
