//
//  UserStorage.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 23.07.2024.
//

import Foundation

@propertyWrapper
struct UserStorage {
    private let filename: String

    init(key: String) {
        self.filename = key
    }

    var wrappedValue: User? {
        get {
            return FileManager.load(filename, as: User.self)
        }
        set {
            _ = FileManager.save(newValue, to: filename)
        }
    }
}
