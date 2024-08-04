//
//  RouteDataView.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 20.06.2024.
//

import Foundation
import SwiftUI

struct RouteDataView: View {
    @EnvironmentObject var auth: AuthController
    @EnvironmentObject var currentRoute: CurrentRouteManager
    @ObservedObject var viewModel: RouteViewModel
    
    var body: some View {
        VStack(spacing: 25) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(viewModel.route.name)
                        .screenHeadline()
                    
                    RouteLabelRow(route: viewModel.route)
                }
                
                Spacer()
                
                Image("Route3DIcon")
                    .icon(size: 70)
            }
            
            HStack(spacing: 0) {
                FirstButton
                
                SecondButton

                ThirdButton
            }
            
            HStack {
                Text(viewModel.route.description)
                Spacer()
            }
            
            RouteMapContent(route: $viewModel.route)
            
            HStack {
                SectionHeader(headline: .constant("Stops"))
                Spacer()
            }
            
            RouteStopsList(route: $viewModel.route)
        }
    }
    
    private var FirstButton: some View {
        RouteButton.publish.view
            .overlay(
                Rectangle()
                    .frame(width: 1),
                alignment: .trailing
            )
    }
    
    private var SecondButton: some View {
        Button(action: {
            viewModel.isEditSheetPresented = true
        }) {
            RouteButton.edit.view
        }
        .overlay(
            Rectangle()
                .frame(width: 1),
            alignment: .trailing
        )
        .sheet(isPresented: $viewModel.isEditSheetPresented) {
            EditRouteView(viewModel: viewModel)
        }
        .disabled(auth.profile.id != viewModel.route.userCreated.id)
    }
    
    private var ThirdButton: some View {
        NavigationLink(value: RouteNavigation.progress(viewModel.route)) {
            if let currentRoute = currentRoute.routeProgress, currentRoute.route.id == viewModel.route.id {
                RouteButton.current.view
            } else if let finishedRoute = auth.profile.finishedRoutes.first(where: { $0.id == viewModel.route.id }) {
                RouteButton.completed(finishedRoute.finishedDate).view
            } else {
                RouteButton.start.view
            }
        }
    }
}

#Preview {
    ScrollView(showsIndicators: false) {
        RouteDataView(viewModel: RouteViewModel(route: MockData.Routes[0]))
    }
    .environmentObject(AuthController())
    .environmentObject(CurrentRouteManager())
    .padding()
}
