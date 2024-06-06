//
//  ImageStyles.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 31.05.2024.
//

import Foundation
import SwiftUI

extension Image {

    func profilePicture(size: Double = 100) -> some View {
        self
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: size, height: size)
            .cornerRadius(100)
    }

}

#Preview {
    VStack {
        Image("Anna")
            .profilePicture()
    }
}
