//
//  CreateStopsView.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 21.06.2024.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers

struct CreateStopsView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var auth: AuthController
    @StateObject var viewModel: RouteStopsViewModel
    @Binding var tabSelection: Int
    @Binding var path: NavigationPath
    @State var showAttractionSearchView: Bool = false
    @State var confirmRemove: Bool = false
    
    init(tabSelection: Binding<Int>, path: Binding<NavigationPath>) {
        self._tabSelection = tabSelection
        self._path = path
        self._viewModel = StateObject(wrappedValue: RouteStopsViewModel(stops: [], pathes: []))
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
                            
                            if viewModel.stops.count > 0 {
                                Button("Remove all stops") {
                                    confirmRemove = true
                                }
                                .foregroundColor(Color.redAccent)
                                
                                Spacer().frame(height: 40)
                            }
                        }
                    }
                }
                .padding(.all, 20)
            }
            
            if viewModel.stops.count > 1 {
                NavigationLink(value: viewModel.stops) {
                    ButtonView(
                        text: .constant("Continue"),
                        colour: Color.lightBlue,
                        textColour: Color.black,
                        size: .L
                    )
                    .padding(.bottom, 20)
                }
                .navigationDestination(for: [Route.RouteStop].self) { value in
                    FinishCreateView(stops: value, pathes: viewModel.pathes, tabSelection: $tabSelection, path: $path)
                }
            }
        }
        .popup(
            isPresented: $confirmRemove,
            text: "Are you sure you want to remove all the stops from the current route?",
            buttonText: "Start the route over"
        ) {
            viewModel.removeAllStops()
        }
        .fullScreenCover(isPresented: $showAttractionSearchView) {
            NavigationStack {
                AttractionsSearchView(routeViewModel: viewModel)
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .tabBar)
        .navigationBarItems(
            leading: BackButton(text: "Back") {
                self.presentationMode.wrappedValue.dismiss()
            }
        )
    }
    
    var ListHeader: some View {
        HStack {
            SectionHeader(headline: .constant("Stops"))
            Spacer()
            
            if viewModel.stops.count > 0 {
                if viewModel.draggingItem != nil {
                    HStack {
                        Text("Delete stop")
                            .font(.system(size: 16, weight: .light))
                            .foregroundColor(Color.redAccent)
                        
                        Image("TrashiOSIcon")
                            .icon(size: viewModel.deleteIconSize, colour: Color.redAccent)
                            .fontWeight(.ultraLight)
                    }
                    .onDrop(
                        of: [UTType.text],
                        delegate:
                            DeleteCardDropDelegate(
                                current: $viewModel.draggingItem,
                                viewModel: viewModel
                            )
                    )
                } else {
                    NavigationLink(destination: {
                        MapRouteView(stops: viewModel.stops, pathes: viewModel.pathes)
                            .toolbar(.hidden, for: .tabBar)
                    }) {
                        MapLinkButton()
                    }
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
                
                RouteStopCard(
                    viewModel: viewModel,
                    stop: $viewModel.stops[index],
                    isDragged: $viewModel.draggingItem
                )
                .onDrag {
                    viewModel.draggingItem = viewModel.stops[index]
                    return NSItemProvider(object: String(index) as NSString)
                }
                .onDrop(
                    of: [UTType.text],
                    delegate:
                        RouteStopCardDropDelegate(
                            item: viewModel.stops[index],
                            current: $viewModel.draggingItem,
                            stops: $viewModel.stops,
                            viewModel: viewModel
                        )
                )
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
    CreateStopsView(
        tabSelection: .constant(2),
        path: .constant(NavigationPath())
    )
    .environmentObject(AuthController())
}
