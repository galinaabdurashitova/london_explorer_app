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
                        openInGoogleMaps()
                    }
                    
                    ButtonView(
                        text: .constant("Open in\nApple Maps"),
                        colour: Color.blueAccent,
                        textColour: Color.white,
                        size: .M
                    ) {
                        openInAppleMaps()
                    }
                }
            }
            .frame(height: 200)
            .padding(.bottom, geometry.size.height - 200)
        }
    }
    
    private func openInGoogleMaps() {
        let address = URLEncoder().encode(attraction.address)
         
        let googleMapsURLString = "comgooglemaps://?q=\(address)"
        let webGoogleMapsURLString = "https://maps.google.com/?q=\(address)"
         
         if let url = URL(string: googleMapsURLString), UIApplication.shared.canOpenURL(url) {
             print(googleMapsURLString)
             UIApplication.shared.open(url, options: [:], completionHandler: nil)
         } else if let url = URL(string: webGoogleMapsURLString) {
             print(webGoogleMapsURLString)
             UIApplication.shared.open(url, options: [:], completionHandler: nil)
         }
    }
    
    private func openInAppleMaps() {
        let address = URLEncoder().encode(attraction.address)
        
        let appleMapsURLString = "maps://?address=\(address)"
        print(appleMapsURLString)
        
        if let url = URL(string: appleMapsURLString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

#Preview {
    AttractionSheetContent(attraction: .constant(MockData.Attractions[0]))
        .padding()
}
