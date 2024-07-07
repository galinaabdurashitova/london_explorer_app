//
//  AttractionView.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 08.06.2024.
//

import Foundation
import SwiftUI

struct AttractionView: View {
    //@EnvironmentObject var networkMonitor: NetworkMonitor
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: AttractionSearchViewModel
    @State var attraction: Attraction
    
    @State private var scrollOffset: CGFloat = 0
    
    private var headerHeight: CGFloat {
        max(110, 315 - max(0, scrollOffset * 2.5 - 100))
    }
    
    private var headerOpacity: Double {
        return Double(headerHeight - scrollOffset * 2) / 100
    }
    
    var body: some View {
        VStack (spacing: -60) {
            ZStack (alignment: .topLeading) {
                ImagesSlidesHeader(images: attraction.images)
                    .frame(height: headerHeight)
                    .clipped()
                    .padding(.vertical, 0)
                    .edgesIgnoringSafeArea(.top)
                    .opacity(headerOpacity)
                
                Header
            }
            .frame(height: headerHeight)
            
            ScrollView (showsIndicators: false) {
                VStack (spacing: 20) {
                    Spacer().frame(height: 10)
                    HStack {
                        VStack (alignment: .leading, spacing: 5) {
                            Text(attraction.name)
                                .screenHeadline()
                            Text(attraction.shortDescription)
                                .subheadline()
                        }
                        Spacer()
                    }
                    
                    AttractionCategoriesCarousel(categories: $attraction.categories)
                    
                    Text(attraction.fullDescription)
                        .font(.system(size: 16))
                    
                    MapContent(attraction: $attraction)
                    
                    Spacer().frame(height: 80)
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
            
            AddButton
        }
        .animation(.easeInOut, value: headerHeight)
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .tabBar)
    }
    
    private var Header: some View {
        HStack {
            BackButton() {
                self.presentationMode.wrappedValue.dismiss()
            }
            
            Spacer()
            
            Text(attraction.name)
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
    
    private var AddButton: some View {
        if !(viewModel.stops.map{ $0.attraction }).contains(attraction) {
            ButtonView(
                text: .constant("Add to the route"),
                colour: Color.blueAccent,
                textColour: Color.white,
                size: .L
            ) {
                viewModel.toggleAttracation(attraction: attraction)
                self.presentationMode.wrappedValue.dismiss()
            }
            .padding(.bottom, 20)
        } else {
            ButtonView(
                text: .constant("Remove from the route"),
                colour: Color.redAccent,
                textColour: Color.white,
                size: .L
            ) {
                viewModel.toggleAttracation(attraction: attraction)
                self.presentationMode.wrappedValue.dismiss()
            }
            .padding(.bottom, 20)
        }
    }
}


#Preview {
    AttractionView(
        viewModel: AttractionSearchViewModel(),
        attraction: MockData.Attractions[0]
    )
    //.environmentObject(NetworkMonitor())
}
