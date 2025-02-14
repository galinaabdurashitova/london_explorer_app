//
//  FavouritesView.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 26.08.2024.
//

import Foundation
import SwiftUI

struct FavouritesView: View {
    @EnvironmentObject var auth: AuthController
    @EnvironmentObject var globalSettings: GlobalSettings
    @StateObject var viewModel: FavouritesViewModel
    
    init(user: User) {
        _viewModel = StateObject(wrappedValue: FavouritesViewModel(user: user))
    }
    
    var body: some View {
        NavigationStack {
            if viewModel.error {
                ErrorScreen {
                    viewModel.loadRoutes()
                }
            } else {
                mainContent
            }
        }
        .onAppear(perform: self.loadScreenData)
    }
    
    private var mainContent: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 25) {
                HStack {
                    ScreenHeader(
                        headline: .constant("Your favourite routes"),
                        subheadline: .constant("You can choose any of the routes you saved")
                    )
                    Spacer()
                }
                
                if viewModel.isLoading {
                    loader
                } else if viewModel.savedRoutes.isEmpty {
                    emptyStateView
                } else {
                    routesList
                }
            }
            .padding()
        }
        .appNavigation()
        .refreshable {
            self.refreshData()
        }
    }
    
    private var routesList: some View {
        VStack(spacing: 20) {
            let numberOfRows = (viewModel.savedRoutes.count + 1) / 2
            ForEach(0..<numberOfRows, id: \.self) { rowIndex in
                HStack(alignment: .top, spacing: 20) {
                    let rowSlice = Array(
                        viewModel.savedRoutes[
                            (rowIndex * 2)..<min(
                                rowIndex * 2 + 2,
                                viewModel.savedRoutes.count
                            )
                        ]
                    )
                    
                    ForEach(rowSlice.indices, id: \.self) { routeRowIndex in
                        let index = rowIndex * 2 + routeRowIndex
                        
                        RouteCard(route: Binding(get: { viewModel.savedRoutes[index] }, set: { _ in }), label: .likes(viewModel.savedRoutes[index].saves.count), size: .S)
                    }
                    
                    if rowSlice.count < 2 {
                        Spacer()
                    }
                }
            }
        }
    }
    
    private var loader: some View {
        VStack(spacing: 20) {
            ForEach(0..<3) { _ in
                HStack(alignment: .top, spacing: 20) {
                    ForEach(0..<2) { _ in
                        VStack(spacing: 5) {
                            Color(Color.black.opacity(0.05))
                                .frame(width: 165, height: 165)
                                .loading(isLoading: true)
                            Color(Color.black.opacity(0.05))
                                .frame(width: 165, height: 20)
                                .loading(isLoading: true)
                            Color(Color.black.opacity(0.05))
                                .frame(width: 165, height: 40)
                                .loading(isLoading: true)
                        }
                    }
                }
            }
        }
    }
    
    private var emptyStateView: some View {
        Button(action: {
            globalSettings.goToTab(.search)
            globalSettings.goToSearchTab(.routes)
        }) {
            ActionBanner(text: "You haven’t saved any routes", actionText: "Search for routes")
        }
    }
    
    private func loadScreenData() {
        if globalSettings.favouriteRoutesReloadTrigger {
            viewModel.loadRoutes()
            globalSettings.setFavouriteRoutesReloadTrigger(to: false)
        }
    }
    
    private func refreshData() {
        if !viewModel.isLoading {
            viewModel.loadRoutes()
        }
    }
}


#Preview {
    FavouritesView(user: MockData.Users[0])
        .environmentObject(AuthController(testProfile: true))
        .environmentObject(GlobalSettings())
}
