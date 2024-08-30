//
//  RouteStopsViewModel.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 10.06.2024.
//

import Foundation
import SwiftUI

class RouteStopsViewModel: ObservableObject {
    @Published var stops: [Route.RouteStop]
    @Published var pathes: [CodableMKRoute?]
    @Published var collectables: [Route.RouteCollectable] = []
    @Published var isLoading: Bool = false
    @Published var draggingItem: Route.RouteStop?
    @Published var deleteIconSize: Double = 25
    
    init(stops: [Route.RouteStop], pathes: [CodableMKRoute?]) {
        self.stops = stops
        self.pathes = pathes
    }
    
    @MainActor
    func calculateRoute() async {
        if stops.count > 1 {
            self.pathes = Array(repeating: nil, count: stops.count-1)
            self.isLoading = true
            for index in 1..<stops.count {
                if let calculatedRouteStep = await RouteMapHelper.calculateRouteStep(start: stops[index-1].attraction.coordinates, destination: stops[index].attraction.coordinates) {
                    self.pathes[index-1] = CodableMKRoute(from: calculatedRouteStep)
                }
            }
            self.isLoading = false
        }
    }
    
    @MainActor
    func updateStopNumbers() {
        for index in self.stops.indices {
            self.stops[index].stepNo = index + 1
        }
    }
    
    func recalculate() async {
        await updateStopNumbers()
        await calculateRoute()
    }
    
    @MainActor
    func deleteStop(stop: Route.RouteStop) {
        if let index = stops.firstIndex(where: { $0 == stop }) {
            self.stops.remove(at: index)
            self.updateStopNumbers()
        }
    }
    
    @MainActor
    func removeAllStops() {
        self.stops = []
        self.pathes = []
    }
    
    @MainActor
    func generateCollectables() {
        let minCollectables = max(1, stops.count - 2)
        let maxCollectables = stops.count + 3
        let collectablesCount = Int.random(in: minCollectables...maxCollectables)
        
        var generatedCollectables: [Route.RouteCollectable] = []
        
        for _ in 0..<collectablesCount {
            if let path = pathes.randomElement() ?? nil, let collectable = Collectable.allCases.randomElement() ?? nil {
                if let randomPoint = RouteMapHelper.getRandomPointOnPath(route: path) {
                    generatedCollectables.append(
                        Route.RouteCollectable(location: randomPoint, type: collectable)
                    )
                }
            }
        }
        
        self.collectables = generatedCollectables
    }
}
