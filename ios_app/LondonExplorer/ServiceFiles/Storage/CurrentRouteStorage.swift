//
//  CurrentRouteStorage.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 23.07.2024.
//

import Foundation

@propertyWrapper
struct CurrentRouteStorage {
    private let filename: String

    init(key: String) {
        self.filename = key
    }

    var wrappedValue: RouteProgress? {
        get {
            return FileManager.load(filename, as: RouteProgress.self)
        }
        set {
            _ = FileManager.save(newValue, to: filename)
        }
    }
}
