//
//  CurrentRoutesStorage.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 04.08.2024.
//

import Foundation

@propertyWrapper
struct CurrentRoutesStorage<T: Codable> {
    private let filename: String

    init(key: String) {
        self.filename = key
    }

    var wrappedValue: T {
        get {
            if let loadedValue: T = FileManager.load(filename, as: T.self) {
                return loadedValue
            } else {
                return (defaultValue() as! T)
            }
        }
        set {
            _ = FileManager.save(newValue, to: filename)
        }
    }
    
    private func defaultValue() -> Any {
        if T.self == Array<RouteProgress>.self {
            return [RouteProgress]()
        }
        
        return ""
    }
}
