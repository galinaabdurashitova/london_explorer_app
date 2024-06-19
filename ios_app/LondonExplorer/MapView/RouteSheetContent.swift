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
//    @Binding var route: Route
    @Binding var routeName: String
    @Binding var stops: [Route.RouteStop]
    @Binding var pathes: [CodableMKRoute?]
    @State var useTestData: Bool = false
    
    // Function used for test view separately - for the preview
//    func buildRoute() async {
//        route.pathes = await MockData.calculateRoute(stops: route.stops).compactMap {
//            $0 != nil ? CodableMKRoute(from: $0!) : nil
//        }
//    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 25) {
                HStack {
                    Text(routeName)
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
                
//                RouteStopsList(route: $route)
                RouteStopsList(stops: $stops, pathes: $pathes)
                
                Spacer()
            }
        }
        .scrollClipDisabled()
//        .onAppear {
//            if useTestData {
//                Task {
//                    await buildRoute()
//                }
//            }
//        }
    }
}

//#Preview {
//    RouteSheetContent(
//        route: Binding<Route> (
//            get: { return MockData.Routes[0] },
//            set: { _ in }
//        ),
//        useTestData: true
//    )
//    .padding()
//}
