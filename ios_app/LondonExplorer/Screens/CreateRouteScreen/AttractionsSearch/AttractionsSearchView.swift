//
//  AttractionsSearchView.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 07.06.2024.
//

import Foundation
import SwiftUI

struct AttractionsSearchView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: AttractionSearchViewModel
    @ObservedObject var routeViewModel: RouteStopsViewModel
    
    init(routeViewModel: RouteStopsViewModel, useTestData: Bool = false) {
        self.routeViewModel = routeViewModel
        self._viewModel = StateObject(wrappedValue: AttractionSearchViewModel(stops: routeViewModel.stops, useTestData: useTestData))
    }
    
    var body: some View {
        ZStack (alignment: .bottom) {
            ScrollView (showsIndicators: false) {
                VStack (spacing: 30) {
                    HStack {
                        ScreenHeader(headline: .constant("Choose attractions"))
                        Spacer()
                    }
                    
                    attractionSearchBar
                    
                    if viewModel.isLoading && viewModel.attractions.count < 1 {
                        loading
                    } else if viewModel.error != nil {
                        ErrorScreen() {
                            viewModel.fetchAttractions()
                        }
                    } else {
                        AttractionsList
                        
                        if viewModel.stops.count > 0 {
                            Spacer().frame(height: 40)
                        }
                    }
                }
                .padding()
            }
                
                
            if viewModel.stops.count > 0, !viewModel.isLoading, viewModel.error == nil {
                ButtonView(
                    text: .constant("Add (\(String(viewModel.stops.count)))"),
                    colour: Color.lightBlue,
                    textColour: Color.black,
                    size: .L
                ) {
                    routeViewModel.stops = viewModel.stops
                    Task {
                        await routeViewModel.calculateRoute()
                    }
                    self.presentationMode.wrappedValue.dismiss()
                }
                .padding(.bottom, 20)
            }
        }
        .toolbar(.hidden, for: .tabBar)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(
            trailing: Button("Cancel") {
                self.presentationMode.wrappedValue.dismiss()
            }
            .foregroundColor(Color.redAccent)
        )
    }
    
    private var attractionSearchBar: some View {
        VStack (spacing: 15) {
            SearchBar(searchText: $viewModel.searchText, showFilter: $viewModel.showFilter, isFilter: true) {
                viewModel.filterAttractions()
            }
            
            if viewModel.showFilter {
                ScrollView (.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(Attraction.Category.allCases) { category in
                            Button(action: {
                                viewModel.toggleCategoryFilter(category: category)
                            }) {
                                CategoryLabel(
                                    category: category,
                                    disabled: .constant(!viewModel.filters.contains(category))
                                )
                            }
                        }
                    }
                }
                .scrollClipDisabled()
            }
        }
    }
    
    private var AttractionsList: some View {
        VStack (spacing: 5) {
            ForEach(viewModel.filters.isEmpty && viewModel.searchText.isEmpty ? $viewModel.attractions : $viewModel.filteredAttractions) { attraction in
                HStack (spacing: 5) {
                    NavigationLink(
                        destination: {
                            AttractionView(stops: $viewModel.stops, attraction: attraction, allowAdd: true)
                    }) {
                        AttractionCard(attraction: attraction)
                    }
                    
                    Button(action: {
                        viewModel.toggleAttracation(attraction: attraction.wrappedValue)
                    }) {
                        AttractionListButton(
                            viewModel: viewModel,
                            attraction: attraction
                        )
                    }
                }
                .padding(.vertical, 10)
                .overlay(
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(Color.black.opacity(0.5)),
                    alignment: .top
                )
            }
        }
    }
    
    private var loading: some View {
        VStack (spacing: 5) {
            ForEach(0..<4) { index in
                VStack(alignment: .leading, spacing: 10) {
                    HStack(spacing: 14) {
                        Color(Color.black.opacity(0.05))
                            .frame(width: 80, height: 80)
                            .loading(isLoading: true)
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Color(Color.black.opacity(0.05))
                                .frame(width: 80, height: 25)
                                .loading(isLoading: true)
                            
                            Color(Color.black.opacity(0.05))
                                .frame(width: 175, height: 55)
                                .loading(isLoading: true)
                        }
                        
                        Spacer()
                    }
                    
                    HStack {
                        ForEach(0..<4) { index in
                            Color(Color.black.opacity(0.05))
                                .frame(width: 70, height: 23)
                                .loading(isLoading: true)
                        }
                    }
                }
                .foregroundColor(Color.black)
            }
            .padding(.vertical, 10)
            .overlay(
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(Color.black.opacity(0.5)),
                alignment: .top
            )
        }
    }
}

#Preview {
    AttractionsSearchView(
        routeViewModel: RouteStopsViewModel(
            stops: MockData.RouteStops,
            pathes: [nil, nil, nil]
        )
    )
}
