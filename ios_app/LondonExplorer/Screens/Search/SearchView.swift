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
                        RouteSearchView(viewModel: viewModel)
                    } else {
                        UsersSearchView(viewModel: viewModel)
                    }
                }
                .padding()
            }
            .refreshable {
                viewModel.getScreenData()
            }
            .appNavigation()
        }
    }
}

#Preview {
    SearchView()
        .environmentObject(AuthController())
        .environmentObject(CurrentRouteManager())
        .environmentObject(GlobalSettings())
}
