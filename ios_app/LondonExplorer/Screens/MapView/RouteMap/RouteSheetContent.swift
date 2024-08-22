//
//  RouteSheetContent.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 11.06.2024.
//

import Foundation
import SwiftUI
import MapKit

struct RouteSheetContent: View {
    @Binding var route: Route
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 25) {
                HStack {
                    Text(route.name.isEmpty ? "New Route" : route.name)
                        .screenHeadline()
                    Spacer()
                }
                
                HStack(spacing: 10) {
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
                
                RouteStopsList(route: $route)
                
                Spacer()
            }
        }
        .scrollClipDisabled()
    }
}

#Preview {
    RouteSheetContent(route: .constant(MockData.Routes[0]))
        .padding()
}
