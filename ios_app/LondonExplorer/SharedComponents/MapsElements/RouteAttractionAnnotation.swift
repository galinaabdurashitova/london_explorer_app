//
//  RouteAttractionAnnotation.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 11.07.2024.
//

import Foundation
import SwiftUI

struct RouteAttractionAnnotation: View {
    @Binding var image: UIImage
    @Binding var index: Int
    
    var body: some View {
        ZStack {
            Rectangle()
                .frame(width: 30, height: 30)
                .rotationEffect(.degrees(45))
                .foregroundColor(Color.redAccent)
                .padding(.top, 50)

            Circle()
                .frame(width: 65, height: 65)
                .foregroundColor(Color.redAccent)
            
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 60, height: 60)
                .cornerRadius(100)
            
            Text(String(index + 1))
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(Color.white)
                .frame(width: 25, height: 25)
                .background(Color.redAccent)
                .cornerRadius(100)
                .padding(.top, -35)
                .padding(.leading, 48)
        }
        .shadow(radius: 5)
        .padding(.top, -95)
    }
}

#Preview {
    RouteAttractionAnnotation(
        image: .constant(UIImage(imageLiteralResourceName: "BigBen")),
        index: .constant(1)
    )
}
