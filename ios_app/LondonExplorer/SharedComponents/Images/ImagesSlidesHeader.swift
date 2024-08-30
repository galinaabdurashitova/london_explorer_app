//
//  ImagesSlidesHeader.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 09.06.2024.
//

import Foundation
import SwiftUI

struct ImagesSlidesHeader: View {
    @Binding var images: [String]
    
    var body: some View {
        TabView {
            ForEach($images, id: \.self) { image in
                HStack {
                    LoadingImage(url: image)
                }
                .clipped()
            }
        }
        .tabViewStyle(PageTabViewStyle())
    }
}

#Preview {
    ImagesSlidesHeader(
        images: .constant(MockData.Attractions[0].imageURLs)
    )
}
