//
//  ServiceErrorEnum.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 12.08.2024.
//

import Foundation

enum ServiceError: Error {
    case noData
    case invalidResponse
    case serverError(Int)
}
