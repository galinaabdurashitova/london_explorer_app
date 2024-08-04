//
//  AttractionCategoriesCarousel.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 08.06.2024.
//

import Foundation
import SwiftUI

struct AttractionCategoriesCarousel: View {
    @Binding var categories: [Attraction.Category]
    @State private var totalWidth: CGFloat = 0
    @State private var screenWidth: CGFloat = 0
    
    var body: some View {
        ScrollView (.horizontal, showsIndicators: false) {
            HStack {
                ForEach(categories) { category in
                    CategoryLabel(category: category)
                        .background(GeometryReader { innerGeometry in
                            Color.clear.onAppear {
                                totalWidth += innerGeometry.size.width
                            }
                        })
                }
                .background(GeometryReader { _ in
                    Color.clear.onAppear {
                        self.screenWidth = screenWidth
                    }
                })
            }

        }
        .scrollClipDisabled()
        .scrollDisabled(totalWidth <= UIScreen.main.bounds.width - 40)
        .onAppear {
            self.totalWidth = 0 // Reset totalWidth to recalculate when the view appears
        }
    }
}

#Preview {
    AttractionCategoriesCarousel(
        categories: Binding<[Attraction.Category]> (
            get: { return MockData.Attractions[0].categories },
            set: { _ in }
        )
    )
    .padding()
}
