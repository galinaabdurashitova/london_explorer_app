//
//  OnRouteWidget.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 31.05.2024.
//

import Foundation
import SwiftUI

struct OnRouteWidget: View {
    @CurrentRouteStorage(key: "LONDON_EXPLORER_CURRENT_ROUTE") var routeProgress: RouteProgress?
    @State var currentRoute: RouteProgress?
    
    var body: some View {
        VStack (spacing: 20) {
            if let routeProgress = currentRoute {
                HStack {
                    SectionHeader(
                        headline: .constant("On a Route!")
                    )
                    Spacer()
                }
                
                RouteProgressView(
                    routeProgress:
                        Binding<RouteProgress> (
                            get: { return routeProgress },
                            set: { _ in }
                        )
                )
            }
        }
        .onAppear {
            currentRoute = routeProgress
        }
    }
}

#Preview {
    OnRouteWidget()
    .padding()
}
