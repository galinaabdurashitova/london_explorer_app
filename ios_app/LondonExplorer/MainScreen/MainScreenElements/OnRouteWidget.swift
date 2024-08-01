//
//  OnRouteWidget.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 31.05.2024.
//

import Foundation
import SwiftUI

struct OnRouteWidget: View {
    @EnvironmentObject var auth: AuthController
    @State var currentRoute: RouteProgress?
    
    @CurrentRouteStorage(key: "LONDON_EXPLORER_CURRENT_ROUTE") var routeProgress: RouteProgress?
    
    var body: some View {
        VStack (spacing: 20) {
            if let currentRoute = currentRoute {
                HStack {
                    SectionHeader(
                        headline: .constant("On a Route!")
                    )
                    Spacer()
                }
                
                RouteProgressView(
                    routeProgress: Binding<RouteProgress> (
                        get: { currentRoute },
                        set: { _ in }
                    )
                )
                .environmentObject(auth)
            }
        }
        .onAppear {
            currentRoute = routeProgress
        }
    }
}

#Preview {
    OnRouteWidget()
        .environmentObject(AuthController())
        .padding()
}
