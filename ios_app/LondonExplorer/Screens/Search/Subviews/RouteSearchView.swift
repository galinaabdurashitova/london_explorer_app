//
//  RouteSearchView.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 28.08.2024.
//

import Foundation
import SwiftUI

struct RouteSearchView: View {
    @ObservedObject var viewModel: SearchViewModel
    
    var body: some View {
        VStack {
            SearchBar(searchText: $viewModel.searchedRoute) {
                viewModel.filterRoutes()
            }
            
            if viewModel.isFetchingRoutes {
                loader
            } else if viewModel.errorRoutes {
                ErrorScreen {
                    Task { await viewModel.fetchRoutes() }
                }
            } else {
                ForEach(viewModel.searchedRoute.isEmpty ? viewModel.routes : viewModel.filteredRoutes) { route in
                    NavigationLink(value: RouteNavigation.info(route)) {
                        routeCard(route: route)
                    }
                }
            }
        }
    }
    
    private func routeCard(route: Route) -> some View {
        HStack {
            Image(uiImage: route.image)
                .roundedFrame(width: 70, height: 70)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(route.name)
                    .sectionCaption()
                    .multilineTextAlignment(.leading)
                RouteLabelRow(route: route)
            }
            .foregroundColor(Color.black)
            
            Spacer()
        }
        .padding(.vertical, 10)
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color.black.opacity(0.5)),
            alignment: .bottom
        )
    }
    
    private var loader: some View {
        VStack {
            ForEach(0..<5) { _ in
                HStack {
                    Color(Color.black.opacity(0.05))
                        .frame(width: 70, height: 70)
                        .loading(isLoading: true)
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Color(Color.black.opacity(0.05))
                            .frame(width: 150, height: 24)
                            .loading(isLoading: true)
                        
                        HStack {
                            ForEach(0..<3) { _ in
                                Color(Color.black.opacity(0.05))
                                    .frame(width: 70, height: 24)
                                    .loading(isLoading: true)
                            }
                        }
                    }
                    
                    Spacer()
                }
                .padding(.vertical, 10)
                .overlay(
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(Color.black.opacity(0.5)),
                    alignment: .bottom
                )
            }
        }
    }
}

#Preview {
    RouteSearchView(viewModel: SearchViewModel())
        .padding()
}
