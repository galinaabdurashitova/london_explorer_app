//
//  RouteLabelRow.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 16.06.2024.
//

import Foundation
import SwiftUI

struct RouteLabelRow: View {
    @Binding var route: Route
    
    var pathTime: String {
        let seconds = route.stops.compactMap { $0.expectedTravelTime }.reduce(0, +) + Double(route.stops.count * 15 * 60)
//        route.pathes.compactMap { $0?.expectedTravelTime }.reduce(0, +) + Double(route.stops.count * 15 * 60)
        let totalMinutes = Int(seconds / 60)
        let hours = totalMinutes / 60
        let minutes = totalMinutes % 60
        return "\(hours)h \(minutes)min"
    }
    
    var body: some View {
        HStack(spacing: 5) {
            Text(String(route.stops.count) + " stops")
                .label()
            
            Text(String(route.collectables) + " collectables")
                .label()
            
            Text(pathTime)
                .label()
        }
    }
}

#Preview {
    RouteLabelRow(route: .constant(MockData.Routes[0]))
}
