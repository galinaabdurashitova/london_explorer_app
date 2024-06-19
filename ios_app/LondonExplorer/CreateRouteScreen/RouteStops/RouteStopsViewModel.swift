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
    @Published var stops: [Route.RouteStop] = []
    @Published var pathes: [CodableMKRoute?] = []
    @Published var isLoading: Bool = false
    @Published var test: Bool = false
    
    init(useTestData: Bool = false) {
        self.pathes = Array(repeating: nil, count: 20)
        if useTestData {
            stops = MockData.RouteStops
            //pathes = [nil, nil, nil]
            Task {
                await calculateRoute()
            }
        }
    }
    
    @MainActor
    func calculateRoute() async {
        print("Starting route calculation")
        if stops.count > 1 {
//            self.pathes = Array(repeating: nil, count: stops.count-1)
            self.isLoading = true
            for index in 1..<stops.count {
                if let calculatedRouteStep = await calculateRouteStep(start: stops[index-1].attraction.coordinates, destination: stops[index].attraction.coordinates) {
//                    self.stops[index].expectedTravelTime = calculatedRouteStep.expectedTravelTime
//                    self.stops[index].pathTo = calculatedRouteStep.polyline.coordinates
                    self.pathes[index-1] = CodableMKRoute(from: calculatedRouteStep)
                }
//                else {
//                    self.pathes[index-1] = nil
//                }
                print("Route step \(index-1) calculated")
            }
            self.isLoading = false
        }
        print("Finished route calculation")
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
        for index in stops.indices {
            stops[index].stepNo = index + 1
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
}
