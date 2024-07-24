//
//  OnRouteViewModel.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 11.07.2024.
//

import Foundation
import SwiftUI
import MapKit

class OnRouteViewModel: ObservableObject {
    @CurrentRouteStorage(key: "LONDON_EXPLORER_CURRENT_ROUTE") var savedRouteProgress: RouteProgress?
    @RoutesStorage(key: "LONDON_EXPLORER_FINISHED_ROUTES") var finishedRoutes: [RouteProgress]
    @Published var routeProgress: RouteProgress
    @Published var currentCoordinate: CLLocationCoordinate2D?
    @Published var directionToStart: MKRoute?
    @Published var mapRegion: MKCoordinateRegion = MKCoordinateRegion()
    @Published var lastStop: Bool = false
    @Published var stopRoute: Bool = false
    @Published var showGreeting: Bool = false
    @Published var greetingText: String = ""
    @Published var greetingSubText: String = ""
    
    private var locationManager = LocationManager()
    
    init(route: Route) {
        self.routeProgress = RouteProgress(
            route: route,
            collectables: 0,
            stops: 0
        )
        
        if let savedRouteProgress = savedRouteProgress {
            if route.id == savedRouteProgress.route.id {
                self.routeProgress = savedRouteProgress
            } else {
                self.showGreeting = true
                self.greetingText = "You're already on another route: \(savedRouteProgress.route.name)"
                self.greetingSubText = "Are you sure you want to start another one?\nYour previous progress won't be saved"
            }
        } else {
            self.showGreeting = true
            self.greetingText = "Start \(route.name)"
            self.greetingSubText = "You're about to start the route! Get ready!"
        }
        
        Task {
            await screenSetup()
        }
    }
    
    init(routeProgress: RouteProgress) {
        self.routeProgress = routeProgress
        
        Task {
            await screenSetup()
        }
    }
    
    func screenSetup() async {
        locationManager.onLocationUpdate = { newCoordinate in
            DispatchQueue.main.async {
                self.currentCoordinate = newCoordinate
            }
            Task {
                await self.getDirectionToStart(start: newCoordinate)
                DispatchQueue.main.async {
                    self.calculateRegion()
                }
            }
        }
    }
    
    func saveRoute() {
        savedRouteProgress = routeProgress
    }
    
    func pause() {
        routeProgress.paused = true
        routeProgress.lastPauseTime = Date()
    }
    
    func resume() {
        if let lastPauseTime = routeProgress.lastPauseTime {
            routeProgress.pauseDuration += Date().timeIntervalSince(lastPauseTime)
        }
        routeProgress.paused = false
        routeProgress.lastPauseTime = nil
    }
    
    func getDirectionToStart(start: CLLocationCoordinate2D) async {
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: start))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: routeProgress.route.stops[0].attraction.coordinates))
        request.transportType = .walking
        
        let directions = MKDirections(request: request)
        do {
            let response = try await directions.calculate()
            if let route = response.routes.first {
                DispatchQueue.main.async {
                    self.directionToStart = route
                }
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
    }
    
    func calculateRegion() {
        var coordinates: [CLLocationCoordinate2D] = []
        
        if routeProgress.stops == 0, let currentCoordinate = currentCoordinate {
            coordinates.append(currentCoordinate)
        } else {
            coordinates.append(routeProgress.route.stops[routeProgress.stops - 1].attraction.coordinates)
        }
        
        if routeProgress.stops < routeProgress.route.stops.count {
            coordinates.append(routeProgress.route.stops[routeProgress.stops].attraction.coordinates)
        }
        
        var minLat = coordinates.first?.latitude ?? 0
        var maxLat = coordinates.first?.latitude ?? 0
        var minLon = coordinates.first?.longitude ?? 0
        var maxLon = coordinates.first?.longitude ?? 0
        
        for coordinate in coordinates {
            minLat = min(minLat, coordinate.latitude)
            maxLat = max(maxLat, coordinate.latitude)
            minLon = min(minLon, coordinate.longitude)
            maxLon = max(maxLon, coordinate.longitude)
        }
        
        let center = CLLocationCoordinate2D(
            latitude: minLat,
//            latitude: (minLat + maxLat) / 2,
            longitude: (minLon + maxLon) / 2
        )
        
        let span = MKCoordinateSpan(
            latitudeDelta: (maxLat - minLat) * 3, // 1.5,
            longitudeDelta: (maxLon - minLon) * 1.5
        )
        
        mapRegion = MKCoordinateRegion(center: center, span: span)
    }
    
    func changeStop(next: Bool = true) {
        if next {
            if routeProgress.stops < routeProgress.route.stops.count {
                routeProgress.stops += 1
            }
        } else {
            if routeProgress.stops > 0 {
                routeProgress.stops -= 1
            }
        }
        
        if routeProgress.stops < routeProgress.route.stops.count {
            calculateRegion()
        } else {
            lastStop = true
            routeProgress.endTime = Date()
        }
        
        saveRoute()
    }
    
    func finishRoute() {
        routeProgress.endTime = Date()
        finishedRoutes.append(routeProgress)
        eraseProgress()
    }
    
    func eraseProgress() {
        savedRouteProgress = nil
    }
}
