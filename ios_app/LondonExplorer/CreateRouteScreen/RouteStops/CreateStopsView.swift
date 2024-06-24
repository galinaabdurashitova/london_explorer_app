//
//  CreateStopsView.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 21.06.2024.
//

import Foundation
import SwiftUI

struct CreateStopsView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: RouteStopsViewModel
    @Binding var tabSelection: Int
    @Binding var path: NavigationPath
    
    init(tabSelection: Binding<Int>, path: Binding<NavigationPath>) {
        _tabSelection = tabSelection
        _path = path
        viewModel = RouteStopsViewModel(stops: [], pathes: [])
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
                    FinishCreateView(stops: value, pathes: viewModel.pathes, tabSelection: $tabSelection, path: $path)
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
    CreateStopsView(
        tabSelection: .constant(2),
        path: .constant(NavigationPath())
    )
}
