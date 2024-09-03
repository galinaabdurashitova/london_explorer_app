//
//  FriendsOnRouteWidget.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 31.05.2024.
//

import Foundation
import SwiftUI

// Not used in the final project
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
            
            ForEach (friendsProgresses) { route in
                RouteProgressView(
                    image: Binding<String>(
                        get: { return route.route.stops[0].attraction.imageURLs[0] },
                        set: { _ in }
                    ),
                    routeName: Binding<String>(
                        get: { return route.route.name },
                        set: { _ in }
                    ),
                    collectablesDone: Binding<Int>(
                        get: { return route.collectables.count },
                        set: { _ in }
                    ),
                    collectablesTotal: Binding<Int>(
                        get: { return route.route.collectables.count },
                        set: { _ in }
                    ),
                    stopsDone: Binding<Int>(
                        get: { return route.stops },
                        set: { _ in }
                    ),
                    stopsTotal: Binding<Int>(
                        get: { return route.route.stops.count },
                        set: { _ in }
                    ),
                    user: Binding<User?>(
                        get: { return route.user },
                        set: { _ in }
                    )
                )
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
