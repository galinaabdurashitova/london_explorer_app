//
//  SearchView.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 20.08.2024.
//

import Foundation
import SwiftUI

struct SearchView: View {
    @EnvironmentObject var auth: AuthController
    @EnvironmentObject var currentRoute: CurrentRouteManager
    @EnvironmentObject var globalSettings: GlobalSettings
    @StateObject var viewModel: SearchViewModel
    
    init() {
        self._viewModel = StateObject(wrappedValue: SearchViewModel())
    }
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack (spacing: 25) {
                    HStack {
                        ScreenHeader(
                            headline: .constant("Search"),
                            subheadline: .constant("Search for routes or other users")
                        )
                        
                        Spacer()
                    }
                    
                    Picker(selection: $globalSettings.searchTab, label: Text("")) {
                        Text("Routes").tag(0)
                        Text("Users").tag(1)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    if globalSettings.searchTab == 0 {
                        routesSearch
                    } else {
                        userSearch
                    }
                }
                .padding()
            }
            .onAppear {
                viewModel.fetchUsers()
                viewModel.fetchRoutes()
            }
            .appNavigation()
        }
    }
    
    private var userSearch: some View {
        VStack {
            SearchBar(searchText: $viewModel.searchedUser) {
                viewModel.filterUsers()
            }
            
            ForEach(viewModel.searchedUser.isEmpty ? viewModel.users : viewModel.filteredUsers) { user in
                NavigationLink(value: ProfileNavigation.profile(user)) {
                    HStack {
                        if let image = user.image {
                            Image(uiImage: image)
                                .profilePicture(size: 50)
                        } else {
                            Image("User3DIcon")
                                .profilePicture(size: 50)
                        }
                        
                        VStack(alignment: .leading, spacing: 0) {
                            Text(user.name)
                                .sectionCaption()
                            Text("@\(user.userName)")
                                .sectionSubCaption()
                        }
                        .foregroundColor(Color.black)
                        
                        Spacer()
                    }
                    .padding(.vertical, 10)
                    .overlay(
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(Color.black.opacity(0.5)),
                        alignment: .bottom
                    )
                }
            }
        }
    }
    
    private var routesSearch: some View {
        VStack {
            SearchBar(searchText: $viewModel.searchedRoute) {
                viewModel.filterRoutes()
            }
            
            ForEach(viewModel.searchedRoute.isEmpty ? viewModel.routes : viewModel.filteredRoutes) { route in
                NavigationLink(value: RouteNavigation.info(route)) {
                    HStack {
                        Image(uiImage: route.image)
                            .roundedFrame(width: 70, height: 70)
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text(route.name)
                                .sectionCaption()
                            RouteLabelRow(route: route)
                        }
                        .foregroundColor(Color.black)
                        
                        Spacer()
                    }
                    .padding(.vertical, 10)
                    .overlay(
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(Color.black.opacity(0.5)),
                        alignment: .bottom
                    )
                }
            }
        }
    }
}

#Preview {
    SearchView()
        .environmentObject(AuthController())
        .environmentObject(CurrentRouteManager())
        .environmentObject(GlobalSettings())
}
