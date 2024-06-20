//
//  RouteStopsView.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 09.06.2024.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers


struct RouteStopsView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: RouteStopsViewModel //= RouteStopsViewModel()
    @State private var showAttractionSearchView: Bool = false
    @State private var confirmRemove: Bool = false
    @State private var draggingItem: Route.RouteStop?
    
    init(useTestData: Bool = false) {
        viewModel = RouteStopsViewModel(useTestData: useTestData)
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 35) {
                    VStack(spacing: 25) {
                        HStack {
                            ScreenHeader(
                                headline: .constant("New Route"),
                                subheadline: .constant("Select the stops for your route")
                            )
                            Spacer()
                        }
                        
                        VStack(spacing: 25) {
                            ListHeader
                            
                            if viewModel.stops.count > 0 {
                                RouteStopsPath
                            }
                            
                            AddStopsButton
                        }
                        
                    }
                    
                    if viewModel.stops.count > 0 {
                        Button("Remove all stops") {
                            confirmRemove = true
                        }
                        .foregroundColor(Color.redAccent)
                        
                        Spacer().frame(height: 40)
                    }
                }
                .padding(.all, 20)
            }
            .fullScreenCover(isPresented: $showAttractionSearchView) {
                NavigationStack {
                    AttractionsSearchView(routeViewModel: viewModel)
                }
            }
            
            
            if viewModel.stops.count > 1 {
                NavigationLink(destination: {
                    FinishCreateView(stops: viewModel.stops, pathes: viewModel.pathes)
                }) {
                    ButtonView(
                        text: .constant("Continue"),
                        colour: Color.lightBlue,
                        textColour: Color.black,
                        size: .L
                    )
                    .padding(.bottom, 20)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .tabBar)
        .navigationBarItems(
            leading: BackButton(text: "Back") {
                self.presentationMode.wrappedValue.dismiss()
            }
        )
        .popup(
            isPresented: $confirmRemove,
            text: "Are you sure you want to remove all the stops from the current route?",
            buttonText: "Start the route over"
        ) {
            viewModel.removeAllStops()
        }
    }
    
    var ListHeader: some View {
        HStack {
            SectionHeader(headline: .constant("Stops"))
            Spacer()
            
            if viewModel.stops.count > 0 {
                NavigationLink(destination: {
                    MapRouteView(stops: viewModel.stops, pathes: viewModel.pathes)
                    .toolbar(.hidden, for: .tabBar)
                }) {
                    MapLinkButton()
                }
            }
        }
    }
    
    var RouteStopsPath: some View {
        VStack(spacing: -1) {
            ForEach(viewModel.stops.indices, id: \.self) { index in
                if index > 0, viewModel.pathes.count > index - 1
                {
                    PathConnection(
                        isLoading: $viewModel.isLoading,
                        reversed: index % 2 == 1 ? false : true,
                        path: $viewModel.pathes[index - 1]
                    )
                }
                
                RouteStopCard(viewModel: viewModel, stop: $viewModel.stops[index])
                    .onDrag {
                        self.draggingItem = viewModel.stops[index]
                        return NSItemProvider(object: String(index) as NSString)
                    }
                    .onDrop(of: [UTType.text], delegate: RouteStopCardDropDelegate(item: viewModel.stops[index], current: $draggingItem, stops: $viewModel.stops, viewModel: viewModel))
            }
        }
    }
    
    var AddStopsButton: some View {
        Button(action: {
            showAttractionSearchView = true
        }) {
            HStack {
                Text("Add stops")
                    .foregroundColor(Color.black)
                    .opacity(0.5)
                Spacer()
                
                Image("LocationiOSIcon")
                    .icon(size: 25, colour: Color.redAccent)
            }
            .frame(height: 60)
            .padding(.horizontal, 12)
            .overlay(
                RoundedRectangle(cornerRadius: 10.0)
                    .stroke(Color.redAccent,lineWidth: 1.0)
            )
        }
    }
}

#Preview {
    RouteStopsView(useTestData: true)
}
