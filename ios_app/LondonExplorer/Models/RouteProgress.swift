//
//  RouteProgress.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 31.05.2024.
//

import Foundation
import SwiftUI

struct RouteProgress: Identifiable, Codable, Hashable, Equatable {
    static func == (lhs: RouteProgress, rhs: RouteProgress) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(route)
        hasher.combine(collectables)
        hasher.combine(newCollectables)
        hasher.combine(stops)
        hasher.combine(user)
        hasher.combine(startTime)
        hasher.combine(endTime)
        hasher.combine(paused)
        hasher.combine(lastPauseTime)
    }
    
    var id = UUID()
    var route: Route
    var collectables: Int
    var newCollectables: [Route.RouteCollectable] = []
    var stops: Int
    var user: User
    var startTime: Date = Date()
    var endTime: Date?
    var paused: Bool = false
    var pauseDuration: TimeInterval = 0
    var lastPauseTime: Date?
    
    func elapsedTime() -> ( String, String) {
        let now = Date()
        let totalPauseDuration = pauseDuration + (paused ? now.timeIntervalSince(lastPauseTime ?? now) : 0)
        let elapsed = now.timeIntervalSince(startTime) - totalPauseDuration
        let hours = Int(elapsed) / 3600
        let minutes = Int(elapsed) / 60 % 60
        return (String(format: "%01d", hours), String(format: "%02d", minutes))
    }
}
