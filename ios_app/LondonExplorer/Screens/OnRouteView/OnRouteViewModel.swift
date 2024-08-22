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
    /// Model used in the view variables
    @Published var routeProgress: RouteProgress
    
    /// Map variables
    @Published var currentCoordinate: CLLocationCoordinate2D?
    @Published var directionToStart: MKRoute?
    @Published var mapRegion: MKCoordinateRegion = MKCoordinateRegion()
    
    /// Variables for correct view work
    @Published var lastStop: Bool = false
    @Published var stopRoute: Bool = false
    @Published var showGreeting: Bool = false
    @Published var greetingText: String = ""
    @Published var greetingSubText: String = ""
    @Published var error: String = ""
    @Published var isMapLoading: Bool = false
    @Published var collected: Route.RouteCollectable?
    @Published var awarded: [User.UserAward] = []
    
    /// Service variables
    private var locationManager = LocationManager()
    private var usersService = UsersService()
    
    /// Initializers
    init(route: Route, user: User, savedRouteProgress: RouteProgress?) {
        self.routeProgress = RouteProgress(
            route: route,
            collectables: [],
            stops: 0,
            user: user
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
            
            if let lastRoute = user.finishedRoutes.first(where: { $0.routeId == route.id }) {
                if lastRoute.collectables < route.collectables.count {
                    self.greetingText = "Ready to find them all?"
                    self.greetingSubText = "Last time you found \(lastRoute.collectables) collectable on \(route.name), there are \(route.collectables.count - lastRoute.collectables) more!"
                } else {
                    self.greetingText = "Ready to repeat?"
                    self.greetingSubText = "You found all collectables on \(route.name), but you can still enjoy the walk!"
                }
            } else {
                self.greetingText = "Start \(route.name)"
                self.greetingSubText = "You're about to start the route! Get ready!"
            }
        }
        
        Task { await self.screenSetup() }
    }
    
    init(routeProgress: RouteProgress) {
        self.routeProgress = routeProgress
        
        Task { await self.screenSetup() }
    }
    
    /// Screen setup functions
    func screenSetup() async {
        self.isMapLoading = true
        locationManager.onLocationUpdate = { newCoordinate in
            DispatchQueue.main.async { self.currentCoordinate = newCoordinate }
            Task {
                await self.getDirectionToStart(start: newCoordinate)
                DispatchQueue.main.async {
                    self.calculateRegion()
                }
            }
        }
        
        self.isMapLoading = false
    }
    
    /// Route progress management functions
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
    
    @MainActor
    func changeStop(next: Bool = true, user: User) {
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
            self.awarded = AwardTypes.AwardTriggers.finishedRoute.getAwards(user: user, routeProgress: self.routeProgress)
        }
    }
    
    func finishRoute(userId: String) throws {
        self.routeProgress.endTime = Date()

        Task {
            do {
                try await usersService.saveFinishedRoute(userId: userId, route: self.routeProgress)
                if !self.awarded.isEmpty {
                    try await usersService.saveUserAward(userId: userId, awards: self.awarded)
                }
            } catch {
                print("Error saving finished route: \(error.localizedDescription)")
                throw error
            }
        }
    }
    
    /// Collectables management functions
    func isAppearCollectable(collectable: Route.RouteCollectable) -> Bool {
        if let currentCoordinate = self.currentCoordinate {
            let location1 = CLLocation(latitude: currentCoordinate.latitude, longitude: currentCoordinate.longitude)
            let location2 = CLLocation(latitude: collectable.location.latitude, longitude: collectable.location.longitude)
            
            return location1.distance(from: location2) < 750 // Collectable appear in this amount of meters
        }
        return false
    }
    
    func collectCollectable() {
        if let collectedItem = self.collected, !self.routeProgress.collectables.contains(collectedItem) {
            self.routeProgress.collectables.append(collectedItem)
        }
        
        withAnimation(.easeInOut) { self.collected = nil }
    }
    
    /// Map management functions
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
        
//        DispatchQueue.main.async {
            self.mapRegion = MKCoordinateRegion(center: center, span: span)
//        }
    }
}
