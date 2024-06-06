//
//  FriendsOnRouteWidget.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 31.05.2024.
//

import Foundation
import SwiftUI

struct FriendsOnRouteWidget: View {
    @Binding var routes: [RouteProgress]
    
    var body: some View {
        VStack (spacing: 20) {
            HStack {
                SectionHeader(
                    headline: .constant("Friends on a Route")
                )
                Spacer()
            }
            
            ForEach ($routes) { route in
                if let friend = route.user.wrappedValue {
                    RouteProgressView(route: route, user: route.user)
                }
            }
        }
    }
}

#Preview {
    FriendsOnRouteWidget(
        routes: Binding<[RouteProgress]> (
            get: { return MockData.RouteProgress },
            set: { _ in }
        )
    )
    .padding()
}
