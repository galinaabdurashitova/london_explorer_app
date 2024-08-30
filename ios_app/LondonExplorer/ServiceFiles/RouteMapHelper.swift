//
//  RouteMapHelper.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 25.08.2024.
//

import Foundation
import MapKit

class RouteMapHelper {
    /// Route path calculation
    static func calculateRouteStep(start: CLLocationCoordinate2D, destination: CLLocationCoordinate2D) async -> MKRoute? {
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
        return nil
    }
    
    private static func getCoordinates(address: String) async throws -> CLLocationCoordinate2D? {
        let geocoder = CLGeocoder()
        if let placemarks = try? await geocoder.geocodeAddressString(address) {
            if let location = placemarks.first?.location?.coordinate {
                return location
            }
        }
        return nil
    }
    
    /// Map region for path calculation
    static func calculateRegion(coordinates: [CLLocationCoordinate2D]) -> MKCoordinateRegion {
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
        
        return MKCoordinateRegion(center: center, span: span)
    }
    
    /// Collectables generation
    static func getRandomPointOnPath(route: CodableMKRoute) -> CLLocationCoordinate2D? {
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
    
    private static func offsetCoordinate(_ coordinate: CLLocationCoordinate2D, by distance: Double, bearing: Double) -> CLLocationCoordinate2D {
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
