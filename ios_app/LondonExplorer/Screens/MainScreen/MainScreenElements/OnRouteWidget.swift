//
//  OnRouteWidget.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 31.05.2024.
//

import Foundation
import SwiftUI

struct OnRouteWidget: View {
    @EnvironmentObject var currentRoute: CurrentRouteManager
    
    var body: some View {
        VStack (spacing: 20) {
            if let routeProgress = currentRoute.routeProgress {
                HStack {
                    SectionHeader(
                        headline: .constant("On a Route!")
                    )
                    Spacer()
                }
                
                NavigationLink(value: routeProgress) {
                    RouteProgressView(
                        image: Binding<String>(
                            get: { return routeProgress.route.stops[0].attraction.imageURLs[0] },
                            set: { _ in }
                        ),
                        routeName: Binding<String>(
                            get: { return routeProgress.route.name },
                            set: { _ in }
                        ),
                        collectablesDone: Binding<Int>(
                            get: { return routeProgress.collectables.count },
                            set: { _ in }
                        ),
                        collectablesTotal: Binding<Int>(
                            get: { return routeProgress.route.collectables.count },
                            set: { _ in }
                        ),
                        stopsDone: Binding<Int>(
                            get: { return routeProgress.stops },
                            set: { _ in }
                        ),
                        stopsTotal: Binding<Int>(
                            get: { return routeProgress.route.stops.count },
                            set: { _ in }
                        )
                    )
                }
            }
        }
    }
}

#Preview {
    OnRouteWidget()
        .environmentObject(AuthController())
        .environmentObject(CurrentRouteManager())
        .padding()
}
