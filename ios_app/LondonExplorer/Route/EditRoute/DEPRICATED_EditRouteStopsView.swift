//
//  EditRouteStopsView.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 21.06.2024.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers

// I decided not to use this view
struct EditRouteStopsView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: RouteStopsViewModel
    @State var route: Route
    
    init(route: Route) {
        self.route = route
        self.viewModel = RouteStopsViewModel(stops: route.stops, pathes: route.pathes)
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 35) {
                    VStack(spacing: 25) {
                        HStack {
                            ScreenHeader(
                                headline: .constant("Edit Route"),
                                subheadline: .constant(route.name)
                            )
                            Spacer()
                        }
                        
                        RouteStopsView(viewModel: viewModel)
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
//                    FinishCreateView(stops: value, pathes: viewModel.pathes, tabSelection: $tabSelection, path: $path)
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
    }
}

#Preview {
    EditRouteStopsView(
        route: MockData.Routes[0]
    )
}
