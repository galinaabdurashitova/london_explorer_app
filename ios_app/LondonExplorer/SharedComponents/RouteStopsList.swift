//
//  RouteStopsList.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 11.06.2024.
//

import Foundation
import SwiftUI

struct RouteStopsList: View {
    @Binding var route: Route
    @State var useTestData: Bool = false
    
    // Function used for test view separately - for the preview
    func buildRoute() async {
        route.pathes = await MockData.calculateRoute(stops: route.stops).compactMap {
            $0 != nil ? CodableMKRoute(from: $0!) : nil
        }
    }
    
    var body: some View {
        ZStack(alignment: .trailing) {
            GeometryReader { geometry in
                Path { path in
                    path.move(to: CGPoint(x: geometry.size.width - 12, y: 37))
                    path.addLine(to: CGPoint(x: geometry.size.width - 12, y: Double((route.stops.count - 1) * 85 + 13)))
                }
                .stroke(style: StrokeStyle( lineWidth: 3, dash: [6]))
                .foregroundColor(Color.grayBackground)
            }
                
            VStack(spacing: 5) {
                ForEach(route.stops.indices) { index in
                    HStack(spacing: 12) {
                        Text(String(index + 1))
                            .font(.system(size: 16, weight: .light))
                            .foregroundColor(Color.gray)
                        
                        route.stops[index].attraction.images[0]
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 50, height: 50)
                            .cornerRadius(8)
                        
                        Text(route.stops[index].attraction.name)
                            .font(.system(size: 18, weight: .medium))
                            .lineLimit(2)
                            .truncationMode(.tail)
                        
                        Spacer()
                        
                        if index == 0 || index == route.stops.count - 1 {
                            Image("LocationiOSIcon")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 25, height: 25)
                                .opacity(0.3)
                        }
                    }
                        
                    if index < route.stops.count - 1 {
                        HStack {
                            Spacer()
                            
                            if let path = route.pathes[index] {
                                Text(
                                    String(format: "%.0f", path.expectedTravelTime / 60)
                                    + " min")
                                .font(.system(size: 12, weight: .medium))
                                .opacity(0.5)
                            }
                                
                            Image("WalkiOSIcon")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 25, height: 25)
                                .opacity(0.5)                            
                        }
                    }
                }
            }
        }
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
    RouteStopsList(
        route: Binding<Route> (
            get: { return MockData.Routes[0] },
            set: { _ in }
        ),
        useTestData: true
    )
    .padding()
}
