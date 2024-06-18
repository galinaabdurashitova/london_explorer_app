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
    @State var useTestData: Bool = false
    
    // Function used for test view separately - for the preview
    func buildRoute() async {
        route.pathes = await MockData.calculateRoute(stops: route.stops).compactMap {
            $0 != nil ? CodableMKRoute(from: $0!) : nil
        }
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 25) {
                HStack {
                    Text(route.name)
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
        .onAppear {
            if useTestData {
                Task {
                    await buildRoute()
                }
            }
        }
    }
}

#Preview {
    RouteSheetContent(
        route: Binding<Route> (
            get: { return MockData.Routes[0] },
            set: { _ in }
        ),
        useTestData: true
    )
    .padding()
}
