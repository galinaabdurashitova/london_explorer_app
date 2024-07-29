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
    @StateObject var viewModel: FinishedRoutesViewModel = FinishedRoutesViewModel()
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                HStack {
                    SectionHeader(
                        headline: .constant("Your Finished Routes"),
                        subheadline: .constant("See the routes that you've finished")
                    )
                    Spacer()
                }
                
                ForEach(viewModel.finishedRoutes, id: \.id) { route in
                    if let existingRoute = route.route {
                        RouteCard(
                            route: Binding<Route>(
                                get: { existingRoute },
                                set: { _ in }
                            ),
                            label: CardLabel.completed(route.finishedDate),
                            size: .M
                        )
                        .environmentObject(auth)
                    }
                }
            }
        }
        .toolbar(.visible, for: .tabBar)
        .padding(.horizontal, 20)
        .padding(.top, 20)
        .onAppear {
            viewModel.setAuthController(auth)
            viewModel.loadRoutes()
        }
    }
}

#Preview {
    FinishedRoutesView()
        .environmentObject(AuthController())
}
