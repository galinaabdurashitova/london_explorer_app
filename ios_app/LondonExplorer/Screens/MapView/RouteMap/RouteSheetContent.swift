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
                
                RouteStopsList(route: $route)
                
                Spacer()
            }
        }
        .scrollClipDisabled()
    }
    
    private func openInGoogleMaps() {
        guard route.stops.count > 1 else { return }
         
        let startCoordinate = route.stops.first!.attraction.coordinates
        let destinationCoordinate = route.stops[1].attraction.coordinates
         
        var daddr = "\(destinationCoordinate.latitude),\(destinationCoordinate.longitude)"
        if route.stops.count > 2 {
            let intermediateStops = route.stops.dropFirst().dropFirst().map {
                "\($0.attraction.coordinates.latitude),\($0.attraction.coordinates.longitude)"
            }
            daddr += "+to:" + intermediateStops.joined(separator: "+to:")
        }
         
        let googleMapsURLString = "comgooglemaps://?saddr=\(startCoordinate.latitude),\(startCoordinate.longitude)&daddr=\(daddr)&directionsmode=walking"
        let webGoogleMapsURLString = "https://maps.google.com/?saddr=\(startCoordinate.latitude),\(startCoordinate.longitude)&daddr=\(daddr)&directionsmode=walking"
         
        if let url = URL(string: googleMapsURLString), UIApplication.shared.canOpenURL(url) {
            print(googleMapsURLString)
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else if let url = URL(string: webGoogleMapsURLString) {
            print(webGoogleMapsURLString)
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    private func openInAppleMaps() {
        guard !route.stops.isEmpty else { return }
        
        let waypoints = route.stops.map { "\(URLEncoder().encode($0.attraction.address))" }.joined(separator: "&daddr=")
        
        let appleMapsURLString = "maps://?saddr=\(waypoints)"
        print(appleMapsURLString)
        
        if let url = URL(string: appleMapsURLString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

#Preview {
    RouteSheetContent(route: .constant(MockData.Routes[0]))
        .padding()
}
