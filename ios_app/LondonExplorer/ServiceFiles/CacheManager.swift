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

    func getCachedData<T>(for key: String) -> T? {
        return cache[key] as? T
    }

    func saveData<T>(_ data: T, for key: String) {
        cache[key] = data
    }

    func invalidateCache(for key: String) {
        cache[key] = nil
    }
}
