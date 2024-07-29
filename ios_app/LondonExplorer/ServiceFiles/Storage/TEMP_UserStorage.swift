//
//  UserStorage.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 23.07.2024.
//

import Foundation

@propertyWrapper
struct UserStorage<T: Codable> {
    private let filename: String

    init(key: String) {
        self.filename = key
    }

    var wrappedValue: T {
        get {
            if let loadedValue: T = FileManager.load(filename, as: T.self) {
//                print("Loaded data from \(filename)")
                return loadedValue
            } else {
//                print("No data found for \(filename), returning default value")
                return (defaultValue() as! T)
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
    
    private func defaultValue() -> Any {
        if T.self == Array<User>.self {
            return [User]()
        }
        // Add other default value cases as needed
        return ""  // Default for other types if needed
    }
}
