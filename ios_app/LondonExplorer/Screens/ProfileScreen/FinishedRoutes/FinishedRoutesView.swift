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
    @StateObject var viewModel: FinishedRoutesViewModel
    
    init(user: User) {
        self._viewModel = StateObject(wrappedValue: FinishedRoutesViewModel(user: user))
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                HStack {
                    let username = viewModel.user.id == auth.profile.id
                    
                    SectionHeader(
                        headline: .constant("\(username ? "Your" : "\(viewModel.user.name)'s") Finished Routes"),
                        subheadline: .constant("\(username ? "You" : viewModel.user.name) finished \(viewModel.finishedRoutes.count) routes")
                    )
                    Spacer()
                }
                
                if viewModel.finishedRoutes.isEmpty {
                    //
                } else {
                    ForEach(viewModel.finishedRoutes, id: \.id) { route in
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
        .onAppear {
            viewModel.loadRoutes()
        }
    }
}

#Preview {
    FinishedRoutesView(user: MockData.Users[0])
        .environmentObject(AuthController())
}
