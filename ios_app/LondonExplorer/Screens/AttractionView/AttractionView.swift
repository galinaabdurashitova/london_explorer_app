//
//  AttractionView.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 08.06.2024.
//

import Foundation
import SwiftUI

struct AttractionView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: AttractionViewModel
    
    private var allowAdd: Bool
    
    @State private var scrollOffset: CGFloat = 0
    private var headerHeight: CGFloat {
        max(50, UIScreen.main.bounds.height * 0.3 - max(0, scrollOffset * 2.5 - 100))
    }
    private var headerOpacity: Double {
        return Double(headerHeight - scrollOffset) / 100
    }
    
    init(stops: Binding<[Route.RouteStop]> = .constant([]), attraction: Binding<Attraction>, allowAdd: Bool) {
        self._viewModel = StateObject(wrappedValue: AttractionViewModel(stops: stops, attraction: attraction))
        self.allowAdd = allowAdd
    }
    
    var body: some View {
        VStack (spacing: 0) {
            ZStack(alignment: .topLeading) {
                ImagesSlidesHeader(images: $viewModel.attraction.imageURLs)
                    .ignoresSafeArea()
                    .padding(.top, -120)
                    .opacity(headerOpacity)
                
                Header
            }
            .frame(height: headerHeight)
            
            ZStack(alignment: .bottom) {
                viewContent
                
                if allowAdd {
                    AddButton
                }
            }
        }
        .animation(.easeInOut, value: headerHeight)
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .tabBar)
    }
    
    private var viewContent: some View {
        ScrollView (showsIndicators: false) {
            VStack (spacing: 20) {
                Spacer().frame(height: 10)
                HStack {
                    VStack (alignment: .leading, spacing: 5) {
                        Text(viewModel.attraction.name)
                            .screenHeadline()
                        Text(viewModel.attraction.shortDescription)
                            .subheadline()
                    }
                    Spacer()
                }
                
                AttractionCategoriesCarousel(categories: $viewModel.attraction.categories)
                
                Text(viewModel.attraction.fullDescription)
                    .font(.system(size: 16))
                
                MapContent(attraction: $viewModel.attraction)
                
                Spacer().frame(height: allowAdd ? 80 : 40)
            }
            .background(
                GeometryReader { geometry in
                    Color.clear
                        .preference(key: ScrollOffsetPreferenceKey.self, value: geometry.frame(in: .named("scroll")).minY)
                }
            )
        }
        .padding(.horizontal)
        .coordinateSpace(name: "scroll")
        .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
            scrollOffset = -value
        }
    }
    
    private var Header: some View {
        HStack {
            BackButton() {
                self.presentationMode.wrappedValue.dismiss()
            }
            
            Spacer()
            
            Text(viewModel.attraction.name)
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
    
    private var AddButton: some View {
        VStack {
            if !(viewModel.stops.map{ $0.attraction }).contains(viewModel.attraction) {
                ButtonView(
                    text: .constant("Add to the route"),
                    colour: Color.blueAccent,
                    textColour: Color.white,
                    size: .L,
                    action: self.toggleAttraction
                )
            } else {
                ButtonView(
                    text: .constant("Remove from the route"),
                    colour: Color.redAccent,
                    textColour: Color.white,
                    size: .L,
                    action: self.toggleAttraction
                )
            }
        }
        .padding(.bottom, UIScreen.main.bounds.height * 0.02)
    }
    
    private func toggleAttraction() {
        viewModel.toggleAttracation(attraction: viewModel.attraction)
        self.presentationMode.wrappedValue.dismiss()
    }
}


#Preview {
    AttractionView(attraction: .constant(MockData.Attractions[0]), allowAdd: true)
}
