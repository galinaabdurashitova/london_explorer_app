//
//  Route.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 30.05.2024.
//

import Foundation
import SwiftUI

struct Route: Identifiable {
    var id = UUID()
    var name: String
    var description: String
    var image: Image
    var saves: Int = 0
    var collectables: Int
    var stops: Int
    var downloadDate: Date?
}
