//
//  CacheManager.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 28.08.2024.
//

import Foundation

class CacheManager {
    static let shared = CacheManager()

    private var cache: [String: Any] = [:]
    private var routeCache: [String: Route] = [:]
    private var attractionCache: [String: Attraction] = [:]

    func getCachedData<T>(for key: String) -> T? {
        return cache[key] as? T
    }

    func saveData<T>(_ data: T, for key: String) {
        cache[key] = data
    }

    func invalidateCache(for key: String) {
        cache[key] = nil
    }
    
    func getRouteCachedData(for key: String) -> Route? {
        return routeCache[key]
    }

    func saveRouteData(_ data: Route, for key: String) {
        routeCache[key] = data
    }

    func invalidateRouteCache(for key: String) {
        routeCache[key] = nil
    }
    
    func getAttractionCachedData(for key: String) -> Attraction? {
        return attractionCache[key]
    }

    func saveAttractionData(_ data: Attraction, for key: String) {
        attractionCache[key] = data
    }

    func invalidateAttractionCache(for key: String) {
        attractionCache[key] = nil
    }
}
