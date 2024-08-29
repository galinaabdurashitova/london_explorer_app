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
                LoadingImage(url: image)
                    .frame(height: 315)
            }
        }
        .tabViewStyle(PageTabViewStyle())
        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
    }
}

#Preview {
    ImagesSlidesHeader(
        images: .constant(MockData.Attractions[0].imageURLs)
    )
}
