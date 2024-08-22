//
//  RoutesStorage.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 19.06.2024.
//

import Foundation

@propertyWrapper
struct RoutesStorage<T: Codable> {
    private let filename: String

    init(key: String) {
        self.filename = key
    }

    var wrappedValue: T {
        get {
            return FileManager.load(filename, as: T.self) ?? [] as! T
        }
        set {
            _ = FileManager.save(newValue, to: filename)
        }
    }
}
