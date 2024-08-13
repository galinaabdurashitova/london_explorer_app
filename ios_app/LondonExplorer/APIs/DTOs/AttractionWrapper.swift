//
//  AttractionWrapper.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 12.08.2024.
//

import Foundation

struct AttractionWrapper: Identifiable, Equatable, Codable, Hashable {
    var id: String
    var name: String
    var shortDescription: String
    var fullDescription: String
    var address: String
    var latitude: Double
    var longitude: Double
    var categories: [String]
}
