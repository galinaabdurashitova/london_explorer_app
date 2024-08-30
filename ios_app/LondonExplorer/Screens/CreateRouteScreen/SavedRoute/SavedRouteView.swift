//
//  SavedRouteView.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 19.06.2024.
//

import Foundation
import SwiftUI

struct SavedRouteView: View {
    @EnvironmentObject var globalSettings: GlobalSettings
    @StateObject var viewModel: RouteViewModel
    @Binding var path: NavigationPath
    
    init(route: Route, path: Binding<NavigationPath>) {
        self._viewModel = StateObject(wrappedValue: RouteViewModel(route: route))
        self._path = path
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 25) {
                    HStack {
                        ScreenHeader(
                            headline: .constant("Get ready for an adventure!"),
                            subheadline: .constant("Your route is saved")
                        )
                        Spacer()
                    }
                    
                    RouteDataView(viewModel: viewModel)
                }
                .padding()
                
                Spacer().frame(height: 80)
            }
            
            HStack(spacing: 10) {
                ButtonView(
                    text: .constant("Create new route"),
                    colour: Color.blueAccent,
                    textColour: Color.white,
                    size: .M
                ) {
                    path.removeLast(path.count)
                }
                
                ButtonView(
                    text: .constant("Go to my profile"),
                    colour: Color.greenAccent,
                    textColour: Color.white,
                    size: .M
                ) {
                    globalSettings.tabSelection = 4
                }
            }
            .padding(.bottom, 20)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.visible, for: .tabBar)
        .error(text: viewModel.errorText, isPresented: $viewModel.showError)
    }
}

#Preview {
    SavedRouteView(
        route: MockData.Routes[0],
        path: .constant(NavigationPath())
    )
    .environmentObject(AuthController())
    .environmentObject(GlobalSettings())
}
