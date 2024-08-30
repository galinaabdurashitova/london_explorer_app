//
//  RouteDataView.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 20.06.2024.
//

import Foundation
import SwiftUI

struct RouteDataView: View {
    @EnvironmentObject var auth: AuthController
    @ObservedObject var viewModel: RouteViewModel
    
    var body: some View {
        VStack(spacing: 25) {
            routeMainInfoBar
            
            RouteButtons(viewModel: viewModel)
            
            HStack {
                Text(viewModel.route.description)
                Spacer()
            }
            
            RouteMapContent(route: $viewModel.route)
            
            HStack {
                SectionHeader(headline: .constant("Stops"))
                Spacer()
            }
            
            RouteStopsList(route: $viewModel.route)
        }
    }
    
    private var routeMainInfoBar: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                userInfo
                
                Text(viewModel.route.name)
                    .screenHeadline()
                
                RouteLabelRow(route: viewModel.route)
            }
            
            Spacer()
            
            Image("Route3DIcon")
                .icon(size: 70)
        }
    }
    
    private var userInfo: some View {
        VStack {
            if auth.profile.id != viewModel.route.userCreated, let user = viewModel.userCreated {
                NavigationLink(value: ProfileNavigation.profile(user)) {
                    HStack(spacing: 5) {
                        LoadingUserImage(userImage: Binding(get: { user.imageName }, set: { _ in }), imageSize: 20)
                        
                        Text(user.name)
                            .headline()
                        
                        Text("shared")
                            .subheadline()
                    }
                    .foregroundColor(Color.black)
                }
            }
        }
    }
    

}

#Preview {
    ScrollView(showsIndicators: false) {
        RouteDataView(viewModel: RouteViewModel(route: MockData.Routes[0]))
    }
    .environmentObject(AuthController())
    .padding()
}
