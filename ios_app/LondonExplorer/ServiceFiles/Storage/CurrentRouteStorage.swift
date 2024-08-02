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
            if let loadedData = FileManager.load(filename, as: RouteProgress.self) {
//                print("Loaded data from \(filename)")
                return loadedData
            } else {
//                print("No data found for \(filename), returning default value")
                return nil
            }
        }
        set {
            if FileManager.save(newValue, to: filename) {
//                print("Successfully saved data to \(filename)")
            } else {
//                print("Failed to save data to \(filename)")
            }
        }
    }
}
