//
//  RouteMapContent.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 20.06.2024.
//

import Foundation
import SwiftUI
import MapKit

struct RouteMapContent: View {
    @Binding var route: Route
    
    var body: some View {
        NavigationLink(value: RouteNavigation.map(route)) {
            VStack {
                HStack (spacing: 5) {
                    Spacer()
                    MapLinkButton()
                }
                
                Map {
                    ForEach(route.stops.indices, id: \.self) { index in
                        if index > 0, let route = route.pathes[index - 1] {
                            MapPolyline(route.polyline.toMKPolyline())
                                .stroke(Color.redAccent, lineWidth: 3)
                        }
                        
                        Marker(route.stops[index].attraction.name, coordinate: route.stops[index].attraction.coordinates)
                    }
                }
                .disabled(true)
                .cornerRadius(10)
                .frame(height: 300)
            }
        }
    }
}

#Preview {
    RouteMapContent(route: .constant(MockData.Routes[0]))
        .padding()
}
