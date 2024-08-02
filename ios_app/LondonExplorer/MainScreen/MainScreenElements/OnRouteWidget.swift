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
    @ObservedObject var viewModel: OnRouteViewModel
    
    var body: some View {
        VStack (spacing: 20) {
            if viewModel.savedRouteProgress != nil {
                HStack {
                    SectionHeader(
                        headline: .constant("On a Route!")
                    )
                    Spacer()
                }
                
                NavigationLink(value: viewModel.routeProgress) {
                    RouteProgressView(routeProgress: $viewModel.routeProgress)
                }
            }
        }
        .onAppear {
            viewModel.loadRouteProgress()
        }
    }
}

#Preview {
    OnRouteWidget(viewModel: OnRouteViewModel())
        .environmentObject(AuthController())
        .padding()
}
