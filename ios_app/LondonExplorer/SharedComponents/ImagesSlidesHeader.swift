//
//  ImagesSlidesHeader.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 09.06.2024.
//

import Foundation
import SwiftUI

struct ImagesSlidesHeader: View {
    @State var images: [UIImage]
    
    var body: some View {
        TabView {
            ForEach(images.indices, id: \.self) { item in
                Image(uiImage: images[item])
                    .resizable()
                    .scaledToFill()
            }
        }
        .tabViewStyle(PageTabViewStyle())
        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
    }
}

#Preview {
    ImagesSlidesHeader(
        images: MockData.Attractions[0].images
    )
    .padding()
}
