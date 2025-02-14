//
//  RouteView.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 20.06.2024.
//

import Foundation
import SwiftUI

struct RouteView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var auth: AuthController
    @EnvironmentObject var globalSettings: GlobalSettings
    @EnvironmentObject var currentRoute: CurrentRouteManager
    @StateObject var viewModel: RouteViewModel
    
    @State private var scrollOffset: CGFloat = 0
    private var headerHeight: CGFloat {
        max(50, UIScreen.main.bounds.height * 0.3 - max(0, scrollOffset * 2.5 - 100))
    }
    private var headerOpacity: Double {
        return Double(headerHeight - scrollOffset) / 100
    }
    
    private var currentUser: Bool {
        auth.profile.id == viewModel.route.userCreated
    }
    
    init(route: Route) {
        self._viewModel = StateObject(wrappedValue: RouteViewModel(route: route))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack (alignment: .topLeading) {
                ImagesSlidesHeader(
                    images: $viewModel.images
                )
                .ignoresSafeArea()
                .padding(.top, -120)
                .opacity(headerOpacity)
                
                Header
            }
            .frame(height: headerHeight)
            
            viewContent
        }
        .onAppear {
            if !self.currentUser && viewModel.userCreated == nil {
                viewModel.fetchUserCreated()
            }
        }
        .animation(.easeInOut, value: headerHeight)
        .toolbar(.visible, for: .tabBar)
        .navigationBarBackButtonHidden(true)
        .error(text: viewModel.errorText, isPresented: $viewModel.showError)
        .popup(
            isPresented: $viewModel.confirmDelete,
            text: "Are you sure you want to delete this route?",
            buttonText: "Delete the route",
            action: self.deleteRoute
        )
    }
    
    private var Header: some View {
        HStack {
            BackButton() {
                self.presentationMode.wrappedValue.dismiss()
            }
            
            Spacer()
            
            Text(viewModel.route.name)
                .font(.headline)
                .fontWeight(.medium)
                .opacity(-headerOpacity)
                .lineLimit(1)
                .truncationMode(.tail)
            
            Spacer()
            
            Color.clear
                .frame(width: 40, height: 40)
        }
        .padding(.horizontal)
    }
    
    private var viewContent: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 25) {
                Spacer().frame(height: 0)
                
                RouteDataView(viewModel: viewModel)
                
                if self.currentUser && viewModel.route.datePublished == nil {
                    Button("Delete the route") {
                        viewModel.confirmDelete(true)
                    }
                    .padding(.top, 20)
                    .foregroundColor(Color.redAccent)
                }
                
                Spacer().frame(height: 20)
            }
            .background(
                GeometryReader { geometry in
                    Color.clear
                        .preference(
                            key: ScrollOffsetPreferenceKey.self,
                            value: geometry
                                    .frame(in: .named("scroll"))
                                    .minY
                        )
                }
            )
        }
        .padding(.horizontal)
        .coordinateSpace(name: "scroll")
        .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
            scrollOffset = -value
        }
    }
    
    private func deleteRoute() {
        viewModel.deleteRoute()
        currentRoute.routeDeletion(route: viewModel.route)
        globalSettings.setProfileReloadTrigger(to: true)
        self.presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    RouteView(route: MockData.Routes[0])
        .environmentObject(AuthController())
        .environmentObject(CurrentRouteManager())
        .environmentObject(GlobalSettings())
}
