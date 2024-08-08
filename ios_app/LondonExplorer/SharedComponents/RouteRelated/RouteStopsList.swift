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
    
    init(route: Binding<Route>) {
        _route = route
    }
    
    init(stops: [Route.RouteStop], pathes: [CodableMKRoute?]) {
        _route = Binding<Route> (
            get: {
                return Route(
                    dateCreated: Date(),
                    userCreated: Route.UserCreated(id: ""),
                    name: "New Route",
                    description: "",
                    image: stops.count > 0 ? stops[0].attraction.images[0] : UIImage(imageLiteralResourceName: "default"),
                    collectables: [],
                    stops: stops,
                    pathes: pathes
                )
            },
            set: { _ in }
        )
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
                ForEach(route.stops.indices, id: \.self) { index in
                    HStack(spacing: 12) {
                        Text(String(index + 1))
                            .font(.system(size: 16, weight: .light))
                            .foregroundColor(Color.gray)
                        
                        Image(uiImage: route.stops[index].attraction.images[0])
                            .roundedFrame(width: 50, height: 50)
                        
                        Text(route.stops[index].attraction.name)
                            .font(.system(size: 18, weight: .medium))
                            .lineLimit(2)
                            .truncationMode(.tail)
                        
                        Spacer()
                        
                        if index == 0 || index == route.stops.count - 1 {
                            Image("LocationiOSIcon")
                                .icon(size: 25, colour: Color.black.opacity(0.3))
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
                                .icon(size: 25, colour: Color.black.opacity(0.5))
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    RouteStopsList(
        route: .constant(MockData.Routes[0])
    )
    .padding()
}
