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
    
    /// User related
    @Published var collected: Route.RouteCollectable?
    @Published var awarded: [User.UserAward] = []
    
    /// Map variables
    @Published var currentCoordinate: CLLocationCoordinate2D?
    @Published var directionToStart: MKRoute?
    @Published var mapRegion: MKCoordinateRegion = MKCoordinateRegion()
    
    /// Route management
    @Published var lastStop: Bool = false
    @Published var stopRoute: Bool = false
    
    /// Greeting
    @Published var greetingText: String = ""
    @Published var greetingSubText: String = ""
    @Published var showGreeting: Bool = false
    
    /// Variables for correct view work
    @Published var error: String = ""
    @Published var showError: Bool = false
    @Published var isMapLoading: Bool = false
    @Published var isFinishing: Bool = false
    
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
    
        self.setGreetingTexts(route: route, user: user, savedRouteProgress: savedRouteProgress)
        Task { await self.screenSetup() }
    }
    
    init(routeProgress: RouteProgress) {
        self.routeProgress = routeProgress
        Task { await self.screenSetup() }
    }
    
    /// Screen setup functions
    private func setGreetingTexts(route: Route, user: User, savedRouteProgress: RouteProgress?) {
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
    }
    
    func screenSetup() async {
        self.isMapLoading = true
        locationManager.onLocationUpdate = { newCoordinate in
            DispatchQueue.main.async { self.currentCoordinate = newCoordinate }
            Task {
                let startPath = await RouteMapHelper.calculateRouteStep(start: newCoordinate, destination: self.routeProgress.route.stops[0].attraction.coordinates)
                DispatchQueue.main.async {
                    self.directionToStart = startPath
                    self.calculateRegion()
                }
            }
        }
        
        self.isMapLoading = false
    }
    
    /// Route progress management functions
    @MainActor
    func pause() {
        self.routeProgress.paused = true
        self.routeProgress.lastPauseTime = Date()
    }
    
    @MainActor
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
            self.awarded = AwardTriggers.finishedRoute.getAwards(user: user, routeProgress: self.routeProgress)
        }
    }
    
    @MainActor
    func finishRoute(userId: String) async {
        self.routeProgress.endTime = Date()

        do {
            try await usersService.saveFinishedRoute(userId: userId, route: self.routeProgress)
            if !self.awarded.isEmpty {
                try await usersService.saveUserAward(userId: userId, awards: self.awarded)
            }
        } catch {
            print("Error saving finished route: \(error.localizedDescription)")
            self.showError = true
            self.error = error.localizedDescription
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
    
    @MainActor
    func collectCollectable() {
        if let collectedItem = self.collected, !self.routeProgress.collectables.contains(collectedItem) {
            self.routeProgress.collectables.append(collectedItem)
        }
        
        withAnimation(.easeInOut) { self.collected = nil }
    }
    
    /// Map management functions
    @MainActor
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
        
        self.mapRegion = RouteMapHelper.calculateRegion(coordinates: coordinates)
    }
    
    /// Utility functions
    @MainActor
    func setGreeting(to value: Bool) {
        self.showGreeting = value
    }
    
    @MainActor
    func setFinishing(to value: Bool) {
        self.isFinishing = value
    }
    
    @MainActor
    func setStopRoute(to value: Bool) {
        self.stopRoute = value
    }
}
