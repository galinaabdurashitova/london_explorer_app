//
//  RouteProgress.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 31.05.2024.
//

import Foundation
import SwiftUI

struct RouteProgress: Identifiable, Codable {
    var id = UUID()
    var route: Route
    var collectables: Int
    var stops: Int
    var user: User?
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
//        let seconds = Int(elapsed) % 60
//        return String(format: "%01d:%02d:%02d", hours, minutes, seconds)
        return (String(format: "%01d", hours), String(format: "%02d", minutes))
    }
}
