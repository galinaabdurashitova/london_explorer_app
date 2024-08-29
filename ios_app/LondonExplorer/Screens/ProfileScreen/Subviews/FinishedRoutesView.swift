//
//  FinishedRoutesView.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 23.07.2024.
//

import Foundation
import SwiftUI

struct FinishedRoutesView: View {
    @EnvironmentObject var auth: AuthController
    @State var user: User
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                HStack {
                    let username = user.id == auth.profile.id
                    
                    SectionHeader(
                        headline: .constant("\(username ? "Your" : "\(user.name)'s") Finished Routes"),
                        subheadline: .constant("\(username ? "You" : user.name) finished \(user.finishedRoutes.count) routes")
                    )
                    Spacer()
                }
                
                let routes = user.finishedRoutes.filter { $0.route != nil }
                
                if routes.isEmpty {
                    //
                } else {
                    ForEach(routes, id: \.self) { route in
                        if let existingRoute = route.route {
                            RouteCard(
                                route: Binding<Route>(
                                    get: { existingRoute },
                                    set: { _ in }
                                ),
                                label: CardLabel.completed(route.finishedDate),
                                size: .M,
                                navigation: RouteNavigation.finishedRoute(route)
                            )
                        }
                    }
                }
            }
        }
        .toolbar(.visible, for: .tabBar)
        .padding(.horizontal)
    }
}

#Preview {
    FinishedRoutesView(user: MockData.Users[0])
        .environmentObject(AuthController())
}
