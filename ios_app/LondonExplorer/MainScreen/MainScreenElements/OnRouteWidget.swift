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
    @Binding var currentRoute: RouteProgress
    
    var body: some View {
        VStack (spacing: 20) {
//            if let currentRoute = currentRoute {
                HStack {
                    SectionHeader(
                        headline: .constant("On a Route!")
                    )
                    Spacer()
                }
                
                RouteProgressView(
                    routeProgress: $currentRoute
                )
                .environmentObject(auth)
//            }
        }
//        .onChange(of: routeProgress) { newValue in
//            currentRoute = newValue
//        }
    }
}

#Preview {
    OnRouteWidget(currentRoute: .constant(MockData.RouteProgress[0]))
        .environmentObject(AuthController())
        .padding()
}
