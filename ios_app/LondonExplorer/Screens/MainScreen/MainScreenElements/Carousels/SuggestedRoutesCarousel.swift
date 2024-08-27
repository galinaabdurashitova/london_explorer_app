//
//  SuggestedRoutesCarousel.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 30.05.2024.
//

import Foundation
import SwiftUI

struct SuggestedRoutesCarousel: View {
    @ObservedObject var viewModel: SuggestedRoutesViewModel
    
    init(viewModel: SuggestedRoutesViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack (spacing: 20) {
            HStack {
                SectionHeader(
                    headline: .constant("Selected for You"),
                    subheadline: .constant("Check out these routes")
                )
                Spacer()
            }
            
            if viewModel.error {
                WidgetError(text: "routes") {
                    viewModel.loadRoutes()
                }
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    if viewModel.isLoading {
                        loader
                    } else {
                        routesList
                    }
                }
                .scrollClipDisabled()
            }
        }
        .onAppear {
            if !viewModel.loaded || viewModel.routes.isEmpty {
                viewModel.loadRoutes()
            }
        }
    }
    
    private var loader: some View {
        HStack (alignment: .top, spacing: 12) {
            ForEach(0..<3) { _ in
                VStack (spacing: 5) {
                    Color(Color.black.opacity(0.05))
                        .frame(width: 165, height: 165)
                        .loading(isLoading: true)
                    Color(Color.black.opacity(0.05))
                        .frame(width: 165, height: 20)
                        .loading(isLoading: true)
                    Color(Color.black.opacity(0.05))
                        .frame(width: 165, height: 40)
                        .loading(isLoading: true)
                }
            }
        }
    }
    
    private var routesList: some View {
        HStack (alignment: .top, spacing: 12) {
            ForEach(viewModel.routes, id: \.id) { route in
                RouteCard(
                    route: Binding(get: { route }, set: { _ in }),
                    label: .likes(route.saves.count),
                    navigation: RouteNavigation.info(route)
                )
            }
        }
    }
}


#Preview {
    SuggestedRoutesCarousel(
        viewModel: SuggestedRoutesViewModel()
    )
    .padding()
}
