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
    @Binding var route: Route
    @State var isEditSheetPresented: Bool = false
    
    init(route: Binding<Route>) {
        self._route = route
    }
    
    var body: some View {
        VStack(spacing: 25) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(route.name)
                        .screenHeadline()
                    
                    RouteLabelRow(route: route)
                }
                
                Spacer()
                
                Image("Route3DIcon")
                    .icon(size: 70)
            }
            
            HStack(spacing: 0) {
                FirstButton
                
                SecondButton
                NavigationLink(destination: {
                    OnRouteView(route: route)
                        .environmentObject(auth)
                }) {
                    ThirdButton
                }
            }
            
            HStack {
                Text(route.description)
                Spacer()
            }
            
            RouteMapContent(route: $route)
            
            HStack {
                SectionHeader(headline: .constant("Stops"))
                Spacer()
            }
            
            RouteStopsList(route: $route)
        }
    }
    
    private var FirstButton: some View {
        RouteButton.publish.view
            .overlay(
                Rectangle()
                    .frame(width: 1),
                alignment: .trailing
            )
    }
    
    private var SecondButton: some View {
        Button(action: {
            isEditSheetPresented = true
        }) {
            RouteButton.edit.view
        }
        .overlay(
            Rectangle()
                .frame(width: 1),
            alignment: .trailing
        )
        .sheet(isPresented: $isEditSheetPresented) {
            EditRouteView(route: $route, isSheetPresented: $isEditSheetPresented)
        }
        .disabled(auth.profile.userId == route.userCreated.id)
    }
    
    private var ThirdButton: some View {
//        NavigationLink(destination: {
//            OnRouteView(route: route, auth: auth)
//                .environmentObject(auth)
//        }) {
            RouteButton.start.view
//        }
    }
}

#Preview {
    ScrollView(showsIndicators: false) {
        RouteDataView(route: .constant(MockData.Routes[0]))
    }
    .environmentObject(AuthController())
    .padding()
}
