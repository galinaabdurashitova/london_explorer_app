//
//  AttractionSheetContent.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 09.06.2024.
//

import Foundation
import SwiftUI

struct AttractionSheetContent: View {
    @Binding var attraction: Attraction
    
    var body: some View {
        GeometryReader { geometry in
            VStack (spacing: 25) {
                HStack {
                    VStack (alignment: .leading, spacing: 5) {
                        Text(attraction.name)
                            .screenHeadline()
                        Text(attraction.shortDescription)
                            .subheadline()
                    }
                    Spacer()
                }
                
                HStack (spacing: 10) {
                    ButtonView(
                        text: .constant("Open in\nGoogle Maps"),
                        colour: Color.blueAccent,
                        textColour: Color.white,
                        size: .M
                    ) {
                        
                    }
                    
                    ButtonView(
                        text: .constant("Open in\nApple Maps"),
                        colour: Color.blueAccent,
                        textColour: Color.white,
                        size: .M
                    ) {
                        
                    }
                }
            }
            .frame(height: 200)
            .padding(.bottom, geometry.size.height - 200)
        }
    }
}

#Preview {
    AttractionSheetContent(attraction: .constant(MockData.Attractions[0]))
        .padding()
}
