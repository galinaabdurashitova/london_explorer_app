//
//  MapContent.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 09.06.2024.
//

import Foundation
import SwiftUI
import MapKit

struct MapContent: View {
    @Binding var attraction: Attraction
    
    var body: some View {
        NavigationLink(destination: {
            MapAttractionView(attraction: $attraction)
                .toolbar(.hidden, for: .tabBar)
        }) {
            VStack {
                HStack (spacing: 5) {
                    Spacer()
                        MapLinkButton()
                }
                
                Map(
                    initialPosition:
                        MapCameraPosition.region(
                            MKCoordinateRegion(
                                center: attraction.coordinates,
                                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                            )
                        )
                ) {
                    Marker(attraction.name, coordinate: attraction.coordinates)
                }
                .disabled(true)
                .cornerRadius(10)
                .frame(height: 300)
            }
        }
    }
}

#Preview {
    MapContent(attraction: .constant(MockData.Attractions[0]))
        .padding()
}
