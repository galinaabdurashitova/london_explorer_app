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
    @EnvironmentObject var currentRoute: CurrentRouteManager
    @State var routes: [Route] = MockData.Routes
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
                    
                    YourRoutesCarousel(routes: $routes, path: $path)
                }
                .padding()
            }
            .appNavigation()
            .navigationDestination(for: CreateRoutePath.self) { value in
                switch value {
                case .routeStops:
                    CreateStopsView(path: $path)
                case .finishCreate(let stops, let pathes, let collectables):
                    FinishCreateView(stops: stops, pathes: pathes, collectables: collectables, path: $path)
                case .savedRoute(let route):
                    SavedRouteView(route: route, path: $path)
                }
            }
        }
    }
}

#Preview {
    CreateRouteView()
        .environmentObject(NetworkMonitor())
        .environmentObject(AuthController())
        .environmentObject(CurrentRouteManager())
}
