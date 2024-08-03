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
                    RouteProgressView(
                        image: $viewModel.routeProgress.route.image,
                        routeName: $viewModel.routeProgress.route.name,
                        collectablesDone: $viewModel.routeProgress.collectables,
                        collectablesTotal: $viewModel.routeProgress.route.collectables,
                        stopsDone: $viewModel.routeProgress.stops,
                        stopsTotal: Binding<Int>(
                            get: {
                                return viewModel.routeProgress.route.stops.count
                            },
                            set: { _ in }
                        )
                    )
                }
            }
        }
        .onChange(of: viewModel.savedRouteProgress) {
            viewModel.loadRouteProgress()
        }
        .onAppear {
            viewModel.loadRouteProgress()
        }
    }
}

class OnRouteWidgetViewModel: ObservableObject {
    @CurrentRouteStorage(key: "LONDON_EXPLORER_CURRENT_ROUTE") var savedRouteProgress: RouteProgress?
    @Published var routeProgress: RouteProgress
    
    init() {
        self.routeProgress = RouteProgress(
            route: MockData.Routes[0],
            collectables: 0,
            stops: 0
        )
        
        self.loadRouteProgress()
    }
    
    func loadRouteProgress() {
        if let savedRouteProgress = self.savedRouteProgress { self.routeProgress = savedRouteProgress }
    }
}

#Preview {
    OnRouteWidget(viewModel: OnRouteViewModel())
        .environmentObject(AuthController())
        .padding()
}
