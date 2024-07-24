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
    @EnvironmentObject var auth: AuthController
    @StateObject var viewModel: FinishCreateViewModel
    @State private var isNavigationActive = false
    @Binding var tabSelection: Int
    @Binding var path: NavigationPath
    
    init(stops: [Route.RouteStop], pathes: [CodableMKRoute?], tabSelection: Binding<Int>, path: Binding<NavigationPath>) {
        self._viewModel = StateObject(wrappedValue: FinishCreateViewModel(stops: stops, pathes: pathes))
        self._tabSelection = tabSelection
        self._path = path
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
                viewModel.saveRoute(userId: auth.profile.userId, userName: auth.profile.name)
                isNavigationActive = true
                path.append(viewModel.route)
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
            .navigationDestination(for: Route.self) { value in
                SavedRouteView(route: value, tabSelection: $tabSelection, path: $path)
                    .environmentObject(auth)
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
        pathes: [nil, nil, nil],
        tabSelection: .constant(2),
        path: .constant(NavigationPath())
    )
    .environmentObject(AuthController())
}
