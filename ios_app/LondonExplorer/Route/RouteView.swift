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
    @ObservedObject var viewModel: RouteViewModel
    @State private var scrollOffset: CGFloat = 0
    @State private var confirmDelete: Bool = false
    
    private var headerHeight: CGFloat {
        max(110, 315 - max(0, scrollOffset * 2.5 - 100))
    }
    
    private var headerOpacity: Double {
        return Double(headerHeight - scrollOffset * 2) / 100
    }
    
    init(route: Binding<Route>) {
        self.viewModel = RouteViewModel(route: route)
    }
    
    var body: some View {
        VStack(spacing: -60) {
            ZStack (alignment: .topLeading) {
                ImagesSlidesHeader(
                    images: viewModel.route.stops.compactMap { stop in
                        stop.attraction.images.first
                    }
                )
                .frame(height: headerHeight)
                .clipped()
                .padding(.vertical, 0)
                .edgesIgnoringSafeArea(.top)
                .opacity(headerOpacity)
                
                Header
            }
            .frame(height: headerHeight)
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 25) {
                    Spacer().frame(height: 0)
                    
                    RouteDataView(route: $viewModel.route)
                    
                    Button("Delete the route") {
                        confirmDelete = true
                    }
                    .padding(.top, 20)
                    .foregroundColor(Color.redAccent)
                    
                    Spacer().frame(height: 20)
                }
                .background(
                    GeometryReader { geometry in
                        Color.clear
                            .preference(key: ScrollOffsetPreferenceKey.self, value: geometry.frame(in: .named("scroll")).minY)
                    }
                )
            }
            .padding(.horizontal, 20)
            .coordinateSpace(name: "scroll")
            .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                scrollOffset = -value
            }
        }
        .animation(.easeInOut, value: headerHeight)
        .toolbar(.visible, for: .tabBar)
        .navigationBarBackButtonHidden(true)
        .popup(
            isPresented: $confirmDelete,
            text: "Are you sure you want to delete this route?",
            buttonText: "Delete the route"
        ) {
            viewModel.deleteRoute()
            self.presentationMode.wrappedValue.dismiss()
        }
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
        .padding(.horizontal, 20)
    }
}

#Preview {
    RouteView(route: .constant(MockData.Routes[0]))
}
