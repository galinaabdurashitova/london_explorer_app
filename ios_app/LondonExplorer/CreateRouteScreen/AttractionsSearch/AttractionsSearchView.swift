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
    
//    init(chosenAttractions: Binding<[Route.RouteStop]>) {
//        _chosenAttractions = chosenAttractions
//        self.viewModel = AttractionSearchViewModel(stops: chosenAttractions.wrappedValue)
//    }
    
    init(routeViewModel: RouteStopsViewModel) {
        self.viewModel = AttractionSearchViewModel(stops: routeViewModel.stops)
        self.routeViewModel = routeViewModel
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
                    
                    AttractionsList
                    
                    if viewModel.stops.count > 0 {
                        Spacer().frame(height: 40)
                    }
                }
                .padding(.all, 20)
            }
            
            
            if viewModel.stops.count > 0 {
                ButtonView(
                    text: .constant("Add (\(String(viewModel.stops.count)))"),
                    colour: Color.lightBlue,
                    textColour: Color.black,
                    size: .L
                ) {
                    routeViewModel.stops = viewModel.stops
                    routeViewModel.pathes = Array(repeating: nil, count: viewModel.stops.count - 1)
//                    Task {
//                        await routeViewModel.calculateRoute()
//                    }
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
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20)
                        .foregroundColor(Color.black.opacity(0.7))
                    TextField("Search", text: $viewModel.searchText)
                        .font(.system(size: 16))
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
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40, height: 40)
                        .foregroundColor(Color.black.opacity(0.5))
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
            ForEach(viewModel.filters.count == 0 ? $viewModel.attractions : $viewModel.filteredAttractions) { attraction in
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
}

#Preview {
    AttractionsSearchView(routeViewModel: RouteStopsViewModel())
//    AttractionsSearchView(chosenAttractions: .constant([]))
        .environmentObject(NetworkMonitor())
}
