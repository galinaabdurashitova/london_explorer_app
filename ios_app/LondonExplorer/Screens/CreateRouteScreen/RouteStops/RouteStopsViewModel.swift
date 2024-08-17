//
//  RouteStopsViewModel.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 10.06.2024.
//

import Foundation
import SwiftUI
import MapKit

class RouteStopsViewModel: ObservableObject {
    @Published var stops: [Route.RouteStop]
    @Published var pathes: [CodableMKRoute?]
    @Published var collectables: [Route.RouteCollectable]
    @Published var isLoading: Bool = false
    @Published var draggingItem: Route.RouteStop?
    @Published var deleteIconSize: Double = 25
    
    init(stops: [Route.RouteStop], pathes: [CodableMKRoute?]) {
        self.stops = stops
        self.pathes = pathes
        self.collectables = []
    }
    
    @MainActor
    func calculateRoute() async {
        if stops.count > 1 {
            self.pathes = Array(repeating: nil, count: stops.count-1)
            self.isLoading = true
            for index in 1..<stops.count {
                if let calculatedRouteStep = await calculateRouteStep(start: stops[index-1].attraction.coordinates, destination: stops[index].attraction.coordinates) {
                    self.pathes[index-1] = CodableMKRoute(from: calculatedRouteStep)
                }
            }
            self.isLoading = false
        }
    }
    
    func calculateRouteStep(start: CLLocationCoordinate2D, destination: CLLocationCoordinate2D) async -> MKRoute? {
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: start))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination))
        request.transportType = .walking

        let directions = MKDirections(request: request)
        do {
            let response = try await directions.calculate()
            if let route = response.routes.first {
                return route
            } else {
                // Debugging: Print out if no routes were found
                print("No routes found")
            }
        } catch {
            print("Error calculating route: \(error.localizedDescription)")
            // Print more detailed error information
            if let error = error as? MKError {
                switch error.code {
                case .placemarkNotFound:
                    print("MKError: Placemark not found")
                case .directionsNotFound:
                    print("MKError: Directions not found")
                case .decodingFailed:
                    print("MKError: Decoding failed")
                case .loadingThrottled:
                    print("MKError: Loading throttled")
                case .serverFailure:
                    print("MKError: Server failure")
                case .unknown:
                    print("MKError: Unknown")
                default:
                    print("MKError: Other error")
                }
            }
        }
        return nil
    }
    
    func getCoordinates(address: String) async throws -> CLLocationCoordinate2D? {
        let geocoder = CLGeocoder()
        if let placemarks = try? await geocoder.geocodeAddressString(address) {
            if let location = placemarks.first?.location?.coordinate {
                return location
            }
        }
        return nil
    }
    
    func updateStopNumbers() {
        DispatchQueue.main.async {
            for index in self.stops.indices {
                self.stops[index].stepNo = index + 1
            }
        }
    }
    
    func recalculate() async {
        updateStopNumbers()
        await calculateRoute()
    }
    
    func deleteStop(stop: Route.RouteStop) {
        if let index = stops.firstIndex(where: { $0 == stop }) {
            stops.remove(at: index)
            updateStopNumbers()
        }
    }
    
    func removeAllStops() {
        stops = []
        pathes = []
    }
    
    func generateCollectables() {
        let minCollectables = max(1, stops.count - 2)
        let maxCollectables = stops.count + 3
        let collectablesCount = Int.random(in: minCollectables...maxCollectables)
        
        var generatedCollectables: [Route.RouteCollectable] = []
        
        for _ in 0..<collectablesCount {
            if let path = pathes.randomElement() ?? nil, let collectable = Collectable.allCases.randomElement() ?? nil {
                if let randomPoint = getRandomPointOnPath(route: path) {
                    generatedCollectables.append(
                        Route.RouteCollectable(location: randomPoint, type: collectable)
                    )
                }
            }
        }
        
//        DispatchQueue.main.async {
            self.collectables = generatedCollectables
//        }
    }
    
    private func getRandomPointOnPath(route: CodableMKRoute) -> CLLocationCoordinate2D? {
        let path = route.polyline.toMKPolyline()
        
        guard path.pointCount > 0 else { return nil }
        
        let randomIndex = Int.random(in: 0..<path.pointCount)
        var point = path.points()[randomIndex].coordinate
        
        // Offset the point by a random distance within 100 meters
        let maxDistance: Double = 500.0 // 100 meters
        
        let randomBearing = Double.random(in: 0..<360)
        let randomDistance = Double.random(in: 0...maxDistance)
        
        point = offsetCoordinate(point, by: randomDistance, bearing: randomBearing)
        
        return point
    }
    
    private func offsetCoordinate(_ coordinate: CLLocationCoordinate2D, by distance: Double, bearing: Double) -> CLLocationCoordinate2D {
        let earthRadius = 6371000.0 // in meters
        
        let bearingRadians = bearing * .pi / 180
        let distanceRatio = distance / earthRadius
        
        let lat1 = coordinate.latitude * .pi / 180
        let lon1 = coordinate.longitude * .pi / 180
        
        let lat2 = asin(sin(lat1) * cos(distanceRatio) + cos(lat1) * sin(distanceRatio) * cos(bearingRadians))
        let lon2 = lon1 + atan2(sin(bearingRadians) * sin(distanceRatio) * cos(lat1), cos(distanceRatio) - sin(lat1) * sin(lat2))
        
        return CLLocationCoordinate2D(latitude: lat2 * 180 / .pi, longitude: lon2 * 180 / .pi)
    }
}
