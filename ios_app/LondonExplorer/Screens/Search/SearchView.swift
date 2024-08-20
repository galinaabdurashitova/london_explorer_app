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
    @StateObject var viewModel: SearchViewModel
    @Binding var tabSelection: Int
    @State var selected: Int = 0
    @State var searchedUser: String = ""
    
    init(tabSelection: Binding<Int>) {
        self._viewModel = StateObject(wrappedValue: SearchViewModel())
        self._tabSelection = tabSelection
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
                    
                    Picker(selection: $selected, label: Text("")) {
                        Text("Routes").tag(0)
                        Text("Users").tag(1)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    if selected == 0 {
                        SearchBar(searchText: .constant("")) {
                            
                        }
                    } else {
                        userSearch
                    }
                }
                .padding(.all, 20)
            }
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
                    ProfileCollectablesView(user: MockData.Users[0])
                case .awards:
                    AwardsView(user: MockData.Users[0])
                case .settings:
                    SettingsView()
                }
            }
        }
    }
    
    private var userSearch: some View {
        VStack {
            SearchBar(searchText: $searchedUser) {
                viewModel.filterUsers()
            }
            
            ForEach(viewModel.searchedUser.isEmpty ? $viewModel.users : $viewModel.filteredUsers) { user in
                NavigationLink(value: ProfileNavigation.profile(user.wrappedValue)) {
                    HStack {
                        if let image = user.image.wrappedValue {
                            Image(uiImage: image)
                                .profilePicture(size: 50)
                        } else {
                            Image("User3DIcon")
                                .profilePicture(size: 50)
                        }
                        
                        VStack(alignment: .leading, spacing: 0) {
                            Text(user.name.wrappedValue)
                                .sectionCaption()
                            Text("@\(user.userName.wrappedValue)")
                                .sectionSubCaption()
                        }
                        
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
    SearchView(tabSelection: .constant(1))
        .environmentObject(AuthController())
        .environmentObject(CurrentRouteManager())
}
