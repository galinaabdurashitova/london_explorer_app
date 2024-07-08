//
//  AttractionsSearchView.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 07.06.2024.
//

import Foundation
import SwiftUI

struct AttractionsSearchView: View {
    @EnvironmentObject var networkMonitor: NetworkMonitor
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: AttractionSearchViewModel
    @ObservedObject var routeViewModel: RouteStopsViewModel
//    @Binding var chosenAttractions: [Route.RouteStop]
    
    init(routeViewModel: RouteStopsViewModel) {
        self.routeViewModel = routeViewModel
        self.viewModel = AttractionSearchViewModel(stops: routeViewModel.stops)
    }
    
    var body: some View {
        ZStack (alignment: .bottom) {
            ScrollView (showsIndicators: false) {
                VStack (spacing: 30) {
                    HStack {
                        ScreenHeader(headline: .constant("Choose attractions"))
                        Spacer()
                    }
                    
                    SearchBar
                    
                    if viewModel.isLoading {
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
                .padding(.all, 20)
            }
                
                
            if viewModel.stops.count > 0, !viewModel.isLoading {
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
    
    private var SearchBar: some View {
        VStack (spacing: 15) {
            HStack (spacing: 15) {
                HStack (spacing: 12) {
                    Image(systemName: "magnifyingglass")
                        .icon(size: 20, colour: Color.black.opacity(0.7))
                    TextField("Search", text: $viewModel.searchText)
                        .font(.system(size: 16))
                        .onChange(of: viewModel.searchText) {
                            viewModel.filterAttractions()
                        }
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 8.0)
                        .stroke(Color.gray, lineWidth: 1.0)
                )
                
                Button(action: {
                    viewModel.showFilter.toggle()
                }) {
                    Image("FilterSFIcon")
                        .icon(size: 40, colour: Color.black.opacity(0.5))
                        .padding(.all, 7)
                        .background(Color.grayBackground)
                        .cornerRadius(8)
                }
            }
            .frame(height: 50)
            
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
            ForEach($viewModel.filteredAttractions) { attraction in
                HStack (spacing: 5) {
                    NavigationLink(
                        destination: {
                            AttractionView(
                                viewModel: viewModel,
                                attraction: attraction.wrappedValue
                            )
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
    .environmentObject(NetworkMonitor())
}
