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

extension FileManager {
    static func save<T: Encodable>(_ object: T, to filename: String) -> Bool {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        guard let documentDirectory = urls.first else { return false }
        let fileURL = documentDirectory.appendingPathComponent(filename)

        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(object)
            try data.write(to: fileURL, options: [.atomicWrite, .completeFileProtection])
            return true
        } catch {
            print("Error saving file: \(error)")
            return false
        }
    }

    static func load<T: Decodable>(_ filename: String, as type: T.Type) -> T? {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        guard let documentDirectory = urls.first else { return nil }
        let fileURL = documentDirectory.appendingPathComponent(filename)

        guard let data = try? Data(contentsOf: fileURL) else { return nil }
        let decoder = JSONDecoder()
        return try? decoder.decode(T.self, from: data)
    }
}
