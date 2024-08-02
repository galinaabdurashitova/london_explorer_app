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
    // Model used in the view variables
    @CurrentRouteStorage(key: "LONDON_EXPLORER_CURRENT_ROUTE") var savedRouteProgress: RouteProgress?
    @Published var routeProgress: RouteProgress
    
    // Map variables
    @Published var currentCoordinate: CLLocationCoordinate2D?
    @Published var directionToStart: MKRoute?
    @Published var mapRegion: MKCoordinateRegion = MKCoordinateRegion()
    
    // Variables for correct view work
    @Published var lastStop: Bool = false
    @Published var stopRoute: Bool = false
    @Published var showGreeting: Bool = false
    @Published var greetingText: String = ""
    @Published var greetingSubText: String = ""
    @Published var error: String = ""
    @Published var isMapLoading: Bool = false
    
    // Service variables
    private var auth: AuthController?
    private var locationManager = LocationManager()
    private var usersService = UsersService()
    
    // Initializers
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
        
        self.isMapLoading = true
        Task {
            await self.screenSetup()
            self.isMapLoading = false
        }
    }
    
    init(routeProgress: RouteProgress) {    // Depricated
        self.routeProgress = routeProgress
        self.isMapLoading = true
        Task {
            await self.screenSetup()
            self.isMapLoading = false
        }
    }
    
    init() {
        self.routeProgress = RouteProgress(
            route: MockData.Routes[0],
            collectables: 0,
            stops: 0
        )
        
        self.loadRouteProgress()
        self.isMapLoading = true
        Task {
            await self.screenSetup()
            self.isMapLoading = false
        }
    }
    
    // Screen setup functions
    func screenSetup() async {
        locationManager.onLocationUpdate = { newCoordinate in
            DispatchQueue.main.async { self.currentCoordinate = newCoordinate }
            Task {
                await self.getDirectionToStart(start: newCoordinate)
            }
            self.calculateRegion()
        }
    }
    
    func setAuthController(_ auth: AuthController) {
        self.auth = auth
    }
    
    // Route progress storing functions
    func loadRouteProgress() {
        if let savedRouteProgress = self.savedRouteProgress { self.routeProgress = savedRouteProgress }
    }
    
    func saveRoute() {
        self.savedRouteProgress = self.routeProgress
    }
    
    func eraseProgress() {
        self.savedRouteProgress = nil
    }
    
    // Route progress management functions
    func pause() {
        self.routeProgress.paused = true
        self.routeProgress.lastPauseTime = Date()
    }
    
    func resume() {
        if let lastPauseTime = self.routeProgress.lastPauseTime {
            self.routeProgress.pauseDuration += Date().timeIntervalSince(lastPauseTime)
        }
        self.routeProgress.paused = false
        self.routeProgress.lastPauseTime = nil
    }
    
    func changeStop(next: Bool = true) {
        if next {
            if self.routeProgress.stops < self.routeProgress.route.stops.count {
                self.routeProgress.stops += 1
            }
        } else {
            if self.routeProgress.stops > 0 {
                self.routeProgress.stops -= 1
            }
        }
        
        if self.routeProgress.stops < self.routeProgress.route.stops.count {
            self.calculateRegion()
        } else {
            self.lastStop = true
            self.routeProgress.endTime = Date()
        }
        
        self.saveRoute()
    }
    
    func finishRoute() throws {
        self.routeProgress.endTime = Date()
        
        Task {
            do {
                if let auth = auth {
                    try await usersService.saveFinishedRoute(userId: auth.profile.id, route: self.routeProgress)
                    auth.profile.finishedRoutes.append(
                        User.FinishedRoute(
                            id: self.routeProgress.route.id,
                            finishedDate: self.routeProgress.endTime!,
                            collectables: self.routeProgress.collectables
                        )
                    )
                    self.eraseProgress()
                } else {
                    throw NSError(domain: "Auth", code: 1, userInfo: [NSLocalizedDescriptionKey: "Authorization error. Saving progress is impossible"])
                }
            } catch {
                throw error
            }
        }
    }
    
    // Map management functions
    func getDirectionToStart(start: CLLocationCoordinate2D) async {
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: start))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: self.routeProgress.route.stops[0].attraction.coordinates))
        request.transportType = .walking
        
        let directions = MKDirections(request: request)
        do {
            let response = try await directions.calculate()
            if let route = response.routes.first {
                DispatchQueue.main.async {
                    self.directionToStart = route
                }
            } else {
                print("No routes found")
            }
        } catch {
            print("Error calculating route: \(error.localizedDescription)")
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
        
        if self.routeProgress.stops == 0, let currentCoordinate = currentCoordinate {
            coordinates.append(currentCoordinate)
        } else {
            coordinates.append(self.routeProgress.route.stops[routeProgress.stops - 1].attraction.coordinates)
        }
        
        if self.routeProgress.stops < self.routeProgress.route.stops.count {
            coordinates.append(self.routeProgress.route.stops[routeProgress.stops].attraction.coordinates)
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
        
        DispatchQueue.main.async {
            self.mapRegion = MKCoordinateRegion(center: center, span: span)
        }
    }
}
