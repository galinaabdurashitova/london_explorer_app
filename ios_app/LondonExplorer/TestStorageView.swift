//
//  TestStorageView.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 04.08.2024.
//

import Foundation
import SwiftUI

struct TestStorageView: View {
    
    @UserStorage(key: "LONDON_EXPLORER_USERS") var users: [User]
    @RoutesStorage(key: "LONDON_EXPLORER_ROUTES") var savedRoutes: [Route]
    @CurrentRouteStorage(key: "LONDON_EXPLORER_CURRENT_ROUTE") var savedRouteProgress: RouteProgress?
    @CurrentRoutesStorage(key: "LONDON_EXPLORER_CURRENT_ROUTES") var savedRoutesProgress: [RouteProgress]

    @RoutesStorage(key: "LONDON_EXPLORER_FINISHED_ROUTES") var finishedRoutes: [RouteProgress]
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            // Users
            VStack {
                Text("Users")
                ForEach(users) { user in
                    HStack {
                        Text(user.name)
                        Text(user.userName)
                    }
                }
            }
            
            // Saved Routes
            VStack {
                Text("Saved routes")
                ForEach(savedRoutes, id: \.id) { route in
                    RouteCard(route: Binding(get: { route }, set: { _ in }))
                }
            }
            
            // Route progress
            VStack {
                Text("Route progress")
                if let savedRouteProgress = savedRouteProgress {
                    RouteProgressView(
                        image: Binding(get: { savedRouteProgress.route.image }, set: { _ in }),
                        routeName: Binding(get: { savedRouteProgress.route.name }, set: { _ in }),
                        collectablesDone: Binding(get: { savedRouteProgress.collectables }, set: { _ in }),
                        collectablesTotal: Binding(get: { savedRouteProgress.route.collectables }, set: { _ in }),
                        stopsDone: Binding(get: { savedRouteProgress.stops }, set: { _ in }),
                        stopsTotal: Binding(get: { savedRouteProgress.route.stops.count }, set: { _ in })
                    )
                }
            }
            
            VStack {
                Text("Route Progresses (array)")
                ForEach(savedRoutesProgress, id: \.id) { savedRouteProgress in
                    RouteProgressView(
                        image: Binding(get: { savedRouteProgress.route.image }, set: { _ in }),
                        routeName: Binding(get: { savedRouteProgress.route.name }, set: { _ in }),
                        collectablesDone: Binding(get: { savedRouteProgress.collectables }, set: { _ in }),
                        collectablesTotal: Binding(get: { savedRouteProgress.route.collectables }, set: { _ in }),
                        stopsDone: Binding(get: { savedRouteProgress.stops }, set: { _ in }),
                        stopsTotal: Binding(get: { savedRouteProgress.route.stops.count }, set: { _ in })
                    )
                }
            }
            
            VStack {
                Text("Finished Progresses (array)")
                ForEach(finishedRoutes, id: \.id) { savedRouteProgress in
                    RouteProgressView(
                        image: Binding(get: { savedRouteProgress.route.image }, set: { _ in }),
                        routeName: Binding(get: { savedRouteProgress.route.name }, set: { _ in }),
                        collectablesDone: Binding(get: { savedRouteProgress.collectables }, set: { _ in }),
                        collectablesTotal: Binding(get: { savedRouteProgress.route.collectables }, set: { _ in }),
                        stopsDone: Binding(get: { savedRouteProgress.stops }, set: { _ in }),
                        stopsTotal: Binding(get: { savedRouteProgress.route.stops.count }, set: { _ in })
                    )
                }
            }
        }
    }
}
