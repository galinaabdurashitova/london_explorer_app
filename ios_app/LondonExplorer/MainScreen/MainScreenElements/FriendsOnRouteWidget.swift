//
//  FriendsOnRouteWidget.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 31.05.2024.
//

import Foundation
import SwiftUI

struct FriendsOnRouteWidget: View {
    @EnvironmentObject var auth: AuthController
    @Binding var friendsProgresses: [RouteProgress]
    
    var body: some View {
        VStack (spacing: 20) {
            HStack {
                SectionHeader(
                    headline: .constant("Friends on a Route")
                )
                Spacer()
            }
            
            ForEach ($friendsProgresses) { route in
                if let friend = route.user.wrappedValue {
                    RouteProgressView(routeProgress: route, user: route.user)
                        .environmentObject(auth)
                }
            }
        }
    }
}

#Preview {
    FriendsOnRouteWidget(
        friendsProgresses: Binding<[RouteProgress]> (
            get: { return MockData.RouteProgress },
            set: { _ in }
        )
    )
    .environmentObject(AuthController())
    .padding()
}
