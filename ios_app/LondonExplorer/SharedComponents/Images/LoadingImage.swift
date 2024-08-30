//
//  LoadingImage.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 28.08.2024.
//

import Foundation
import SwiftUI

struct LoadingImage: View {
    @Binding var url: String
    
    var body: some View {
        if let url = URL(string: self.url) {
            AsyncImage(url: url) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .scaledToFill()
                } else if phase.error != nil {
                    Color.gray.opacity(0.1)
                } else {
                    Color.black.opacity(0.05)
                        .loading(isLoading: true)
                }
            }
        } else {
            Color.gray.opacity(0.1)
        }
    }
}

#Preview {
    LoadingImage(url: .constant(MockData.Attractions[0].imageURLs[0]))
        .roundedFrameView()
}
