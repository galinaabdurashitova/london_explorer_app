//
//  RouteDataView.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 20.06.2024.
//

import Foundation
import SwiftUI

struct RouteDataView: View {
    @Binding var route: Route
    
    var body: some View {
        VStack(spacing: 25) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(route.name)
                        .screenHeadline()
                    
                    RouteLabelRow(route: route)
                }
                
                Spacer()
                
                Image("Route3DIcon")
                    .icon(size: 70)
            }
            
            HStack(spacing: 0) {
                RouteButton.publish.view
                    .overlay(
                        Rectangle()
                            .frame(width: 1),
                        alignment: .trailing
                    )
                
                
                RouteButton.edit.view
                    .overlay(
                        Rectangle()
                            .frame(width: 1),
                        alignment: .trailing
                    )
                
                RouteButton.start.view
            }
            
            HStack {
                Text(route.description)
                Spacer()
            }
            
            RouteMapContent(route: $route)
            
            HStack {
                SectionHeader(headline: .constant("Stops"))
                Spacer()
            }
            
            RouteStopsList(route: $route)
        }
    }
}

#Preview {
    ScrollView(showsIndicators: false) {
        RouteDataView(route: .constant(MockData.Routes[0]))
    }
    .padding()
}
