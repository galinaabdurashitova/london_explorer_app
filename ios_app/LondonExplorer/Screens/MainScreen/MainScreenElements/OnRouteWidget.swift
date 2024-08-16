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
    @Binding var tabSelection: Int
    
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
                        image: Binding<UIImage>(
                            get: { return routeProgress.route.image },
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
    OnRouteWidget(tabSelection: .constant(0))
        .environmentObject(AuthController())
        .environmentObject(CurrentRouteManager())
        .padding()
}
