//
//  LoadingUserImage.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 29.08.2024.
//

import Foundation
import SwiftUI

struct LoadingUserImage: View {
    @Binding var userImage: String?
    @State var imageSize: Double
    
    var body: some View {
        ZStack {
            if let image = userImage {
                LoadingImage(url: Binding(get: { image }, set: { _ in }))
            } else {
                Image("User3DIcon")
                    .resizable()
                    .scaledToFill()
            }
        }
        .profilePictureView(size: imageSize)
    }
}

#Preview {
    LoadingUserImage(userImage: .constant(MockData.Attractions[0].imageURLs[0]), imageSize: 100)
}
