//
//  ServiceClass.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 20.08.2024.
//

import Foundation

class Service {
    internal let baseURL: URL = URL(string: "http://localhost:8080/api")!
    
    func checkResponse(response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw ServiceError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200..<300:
            break
        case 400:
            throw ServiceError.serverError(400)
        case 404:
            throw ServiceError.serverError(404)
        case 500:
            throw ServiceError.serverError(500)
        default:
            throw ServiceError.serverError(httpResponse.statusCode)
        }
    }
}
