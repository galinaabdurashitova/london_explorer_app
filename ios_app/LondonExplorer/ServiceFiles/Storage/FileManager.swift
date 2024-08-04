//
//  FileManager.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 21.07.2024.
//

import Foundation

// ALL CURRENT STORAGES USED
//@UserStorage(key: "LONDON_EXPLORER_USERS") var user: [User]
//@RoutesStorage(key: "LONDON_EXPLORER_ROUTES") var savedRoutes: [Route]
//@CurrentRouteStorage(key: "LONDON_EXPLORER_CURRENT_ROUTE") var savedRouteProgress: RouteProgress?
//@CurrentRoutesStorage(key: "LONDON_EXPLORER_CURRENT_ROUTES") var savedRouteProgress: [RouteProgress]

//@RoutesStorage(key: "LONDON_EXPLORER_FINISHED_ROUTES") var finishedRoutes: [RouteProgress]

extension FileManager {
    static func save<T: Encodable>(_ object: T, to filename: String) -> Bool {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        guard let documentDirectory = urls.first else { return false }
        let fileURL = documentDirectory.appendingPathComponent(filename)

        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(object)
            try data.write(to: fileURL, options: [.atomicWrite, .completeFileProtection])
//            print("Data written to \(fileURL.path)")
            return true
        } catch {
//            print("Error saving file: \(error)")
            return false
        }
    }

    static func load<T: Decodable>(_ filename: String, as type: T.Type) -> T? {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        guard let documentDirectory = urls.first else { return nil }
        let fileURL = documentDirectory.appendingPathComponent(filename)

        guard let data = try? Data(contentsOf: fileURL) else {
//            print("No data found at \(fileURL.path)")
            return nil
        }
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(T.self, from: data)
//            print("Data loaded from \(fileURL.path)")
            return decodedData
        } catch {
//            print("Error loading file: \(error)")
            return nil
        }
    }
}
