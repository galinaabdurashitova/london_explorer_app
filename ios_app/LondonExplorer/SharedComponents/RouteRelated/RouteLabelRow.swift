//
//  RouteLabelRow.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 16.06.2024.
//

import Foundation
import SwiftUI

struct RouteLabelRow: View {
    @State var stops: Int
    @State var collectables: Int
    @State var seconds: Double
    
    var pathTime: String {
        let totalMinutes = Int(seconds / 60)
        let hours = totalMinutes / 60
        let minutes = totalMinutes % 60
        return "\(hours)h \(minutes)min"
    }
    
    init(route: Route) {
        self.stops = route.stops.count
        self.collectables = route.collectables.count
        self.seconds = route.routeTime
    }
    
    init(stops: [Route.RouteStop], collectables: Int = 0, pathes: [CodableMKRoute?]) {
        self.stops = stops.count
        self.collectables = collectables
        self.seconds = pathes.compactMap { $0?.expectedTravelTime }.reduce(0, +) + Double(stops.count * 15 * 60)
    }
    
    var body: some View {
        HStack(spacing: 5) {
            Text(String(stops) + " stops")
                .label()
            
            Text(String(collectables) + " collectables")
                .label()
            
            Text(pathTime)
                .label()
        }
    }
}

#Preview {
    RouteLabelRow(route: MockData.Routes[0])
}
