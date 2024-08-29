//
//  AttractionCard.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 08.06.2024.
//

import Foundation
import SwiftUI

struct AttractionCard: View {
    @Binding var attraction: Attraction
    
    var body: some View {
        VStack (alignment: .leading, spacing: 10) {
            HStack (spacing: 14) {
                LoadingImage(url: $attraction.imageURLs[0])
                    .roundedFrameView(width: 80, height: 80)
                
                VStack (alignment: .leading, spacing: 5) {
                    Text(attraction.name)
                        .font(.system(size: 18, weight: .medium))
                        .kerning(-0.2)
                        .lineLimit(2)
                        .truncationMode(.tail)
                        .multilineTextAlignment(.leading)
                    
                    Text(attraction.shortDescription)
                        .font(.system(size: 14))
                        .opacity(0.5)
                        .lineLimit(2)
                        .truncationMode(.tail)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
            }
            .foregroundColor(Color.black)
            
            AttractionCategoriesCarousel(categories: $attraction.categories)
        }
    }
}

#Preview {
    AttractionCard(attraction: .constant(MockData.Attractions[0]))
        .padding()
}
