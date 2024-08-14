//
//  OnRouteMap.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 14.08.2024.
//

import Foundation
import SwiftUI
import MapKit

struct OnRouteMap: View {
    @ObservedObject var viewModel: OnRouteViewModel
    
    var body: some View {
        Map (
            position:
                Binding<MapCameraPosition>(
                    get: { MapCameraPosition.region(viewModel.mapRegion) },
                    set: { _ in }
                )
        ) {
            // Current location
            UserAnnotation()
            
            if viewModel.routeProgress.stops == 0 {     // If start the route - path from current location
                
                if let currentCoordinate = viewModel.currentCoordinate {
                    Annotation("Start here", coordinate: currentCoordinate) {   // Current location annotated
                        StartMapAnnotation
                    }
                    .annotationTitles(.hidden)
                }
                
                if let path = viewModel.directionToStart {
                    MapPolyline(path.polyline)          // Path
                        .stroke(Color.redAccent, lineWidth: 5)
                }
                
            } else {    // If next stops - current attraction and path to next stop
                
                Annotation(
                    viewModel.routeProgress.route.stops[viewModel.routeProgress.stops - 1].attraction.name,
                    coordinate: viewModel.routeProgress.route.stops[viewModel.routeProgress.stops - 1].attraction.coordinates
                ) {
                    RouteAttractionAnnotation(
                        image: $viewModel.routeProgress.route.stops[viewModel.routeProgress.stops - 1].attraction.images[0],
                        index: Binding<Int> (
                            get: { viewModel.routeProgress.stops - 1 },
                            set: { _ in }
                        )
                    )
                }
                .annotationTitles(.hidden)
                            
                if viewModel.routeProgress.stops < viewModel.routeProgress.route.stops.count, let route = viewModel.routeProgress.route.pathes[viewModel.routeProgress.stops - 1] {
                    MapPolyline(route.polyline.toMKPolyline())
                        .stroke(Color.redAccent, lineWidth: 3)
                }
                
            }
            
            // Always show next attraction, unless current stop == last stop
            if viewModel.routeProgress.stops < viewModel.routeProgress.route.stops.count {
                Annotation(
                    viewModel.routeProgress.route.stops[viewModel.routeProgress.stops].attraction.name,
                    coordinate: viewModel.routeProgress.route.stops[viewModel.routeProgress.stops].attraction.coordinates
                ) {
                    RouteAttractionAnnotation(image: $viewModel.routeProgress.route.stops[viewModel.routeProgress.stops].attraction.images[0], index: $viewModel.routeProgress.stops)
                }
                .annotationTitles(.hidden)
            }
            
            // Collectables
            ForEach(viewModel.routeProgress.route.collectables.indices, id: \.self) { index in
                let currentCollectable = viewModel.routeProgress.route.collectables[index]
                
                if viewModel.isAppearCollectable(collectable: currentCollectable) {
                    Annotation(
                        "Collectable",
                        coordinate: currentCollectable.location
                    ) {
                        if viewModel.routeProgress.collectables.compactMap({ $0.type }).contains(currentCollectable.type) {
                            CollectableAnnotation(color: .constant(Color.gray))
                                .onTapGesture {
                                    withAnimation(.easeInOut) { viewModel.collected = currentCollectable }
                                }
                        } else {
                            CollectableAnnotation(index: Binding<Int?>( get: { index }, set: { _ in }))
                                .onTapGesture {
                                    withAnimation(.easeInOut) { viewModel.collected = currentCollectable }
                                }
                        }
                    }
                }
            }
        }
        .mapControls {
            MapUserLocationButton()
        }
    }
    
    private var StartMapAnnotation: some View {
        ZStack {
            Rectangle()
                .frame(width: 30, height: 30)
                .rotationEffect(.degrees(45))
                .foregroundColor(Color.redAccent)
                .padding(.top, 50)
            
            Circle()
                .frame(width: 65, height: 65)
                .foregroundColor(Color.redAccent)
            
            Text("Start\nhere")
                .foregroundColor(Color.white)
                .font(.system(size: 14, weight: .bold))
        }
        .shadow(radius: 5)
        .padding(.top, -95)
    }
}

#Preview {
    OnRouteMap(viewModel: OnRouteViewModel(routeProgress: MockData.RouteProgress[0]))
}
