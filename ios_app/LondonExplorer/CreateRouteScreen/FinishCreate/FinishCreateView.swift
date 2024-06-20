//
//  FinishCreateView.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 14.06.2024.
//

import Foundation
import SwiftUI
import MapKit

struct FinishCreateView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: FinishCreateViewModel
    @State private var isNavigationActive = false
    
    init(stops: [Route.RouteStop], pathes: [CodableMKRoute?]) {
        self.viewModel = FinishCreateViewModel(stops: stops, pathes: pathes)
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 25) {
                    Header
                    
                    TextFields
                    
                    StopsList
                }
                
                Spacer().frame(height: 85)
            }
            .scrollClipDisabled()
            .padding(.all, 20)
            
            Button(action: {
                viewModel.saveRoute()
                isNavigationActive = true
            }) {
                ButtonView(
                    text: .constant("Save route"),
                    colour: Color.blueAccent,
                    textColour: Color.white,
                    size: .L,
                    disabled: Binding<Bool> (
                        get: { return viewModel.route.name.isEmpty || viewModel.route.description.isEmpty },
                        set: { _ in }
                    )
                )
            }
            .padding(.bottom, 20)
            .navigationDestination(isPresented: $isNavigationActive) {
                SavedRouteView(route: viewModel.route)
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .tabBar)
        .navigationBarItems(
            leading: BackButton(text: "Back") {
                self.presentationMode.wrappedValue.dismiss()
            }
            .foregroundColor(Color.blueAccent)
        )
    }
    
    private var Header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                ScreenHeader(
                    headline: .constant("Well done!"),
                    subheadline: .constant("Your route has")
                )
                
                RouteLabelRow(route: viewModel.route)
            }
            Spacer()
            Image("BigBen3DIcon")
                .icon(size: 80)
        }
    }
    
    private var TextFields: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Now last few deatails")
                .font(.system(size: 14, weight: .light))
                .opacity(0.5)
            
            CustomTextField(fieldText: .constant("Route Name"), fillerText: .constant("Type route name here..."), textVariable: $viewModel.route.name, maxLength: 64)
            
            CustomTextField(fieldText: .constant("Route Description"), fillerText: .constant("Fill in route description..."), textVariable: $viewModel.route.description, height: 200, maxLength: 32000)
        }
    }
    
    private var StopsList: some View {
        VStack(spacing: 25) {
            HStack {
                SectionHeader(headline: .constant("Stops"))
                Spacer()
                
                if viewModel.route.stops.count > 0 {
                    NavigationLink(destination: {
                        MapRouteView(route: viewModel.route)
                            .toolbar(.hidden, for: .tabBar)
                    }) {
                        MapLinkButton()
                    }
                }
            }
            
            RouteStopsList(route: $viewModel.route)
        }
    }
}

#Preview {
    FinishCreateView(
        stops: MockData.RouteStops,
        pathes: [nil, nil, nil]
    )
}
