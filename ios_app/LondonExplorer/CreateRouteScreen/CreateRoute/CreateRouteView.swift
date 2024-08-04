//
//  CreateRouteView.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 07.06.2024.
//

import Foundation
import SwiftUI



struct CreateRouteView: View {
    @EnvironmentObject var networkMonitor: NetworkMonitor
    @EnvironmentObject var auth: AuthController
    @State var routes: [Route] = MockData.Routes
    @Binding var tabSelection: Int
    @State var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            ScrollView(showsIndicators: false) {
                VStack (spacing: 25) {
                    HStack {
                        ScreenHeader(
                            headline: .constant("New Route"),
                            subheadline: .constant("You can create new route or choose from the existing")
                        )

                        Spacer()
                    }
                    
                    YourRoutesCarousel(routes: $routes, tabSelection: $tabSelection, path: $path)
                        .environmentObject(auth)
                    
                    if networkMonitor.isConnected {
                        SuggestedRoutesCarousel(routes: $routes)
                            .environmentObject(auth)
                    } else {
                        DownloadedRoutesWidget(routes: $routes)
                            .environmentObject(auth)
                    }
                }
                .padding(.all, 20)
            }
            .navigationDestination(for: CreateRoutePath.self) { value in
                switch value {
                case .routeStops:
                    CreateStopsView(tabSelection: $tabSelection, path: $path)
                        .environmentObject(auth)
                case .finishCreate(let stops, let pathes):
                    FinishCreateView(stops: stops, pathes: pathes, tabSelection: $tabSelection, path: $path)
                        .environmentObject(auth)
                case .savedRoute(let route):
                    SavedRouteView(route: route, tabSelection: $tabSelection, path: $path)
                        .environmentObject(auth)
                }
            }
            .navigationDestination(for: RouteNavigation.self) { value in
                switch value {
                case .info(let route):
                    RouteView(route: route)
                        .environmentObject(auth)
                case .progress(let route):
                    OnRouteView(route: route, user: auth.profile)
                        .environmentObject(auth)
                case .map(let route):
                    MapRouteView(route: route)
                }
            }
        }
    }
}

#Preview {
    CreateRouteView(tabSelection: .constant(2))
        .environmentObject(NetworkMonitor())
        .environmentObject(AuthController())
}
