//
//  MapLinkButton.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 09.06.2024.
//

import Foundation
import SwiftUI

struct MapLinkButton: View {
    
    var body: some View {
        HStack {
            Text("View Map")
                .font(.system(size: 16, weight: .light))
            
            Image("MapiOSIcon")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 25)
        }
        .foregroundColor(Color.black)
        .opacity(0.5)
    }
}

#Preview {
    MapLinkButton()
        .padding()
}
