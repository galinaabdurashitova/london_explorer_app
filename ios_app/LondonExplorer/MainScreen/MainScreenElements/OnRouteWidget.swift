//
//  OnRouteWidget.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 31.05.2024.
//

import Foundation
import SwiftUI

struct OnRouteWidget: View {
    @Binding var routeProgress: RouteProgress
    
    var body: some View {
        VStack (spacing: 20) {
            HStack {
                SectionHeader(
                    headline: .constant("On a Route!")
                )
                Spacer()
            }
            
            RouteProgressView(routeProgress: $routeProgress)
        }
    }
}

#Preview {
    OnRouteWidget(
        routeProgress: Binding<RouteProgress> (
            get: { return MockData.RouteProgress[0] },
            set: { _ in }
        )
    )
    .padding()
}
