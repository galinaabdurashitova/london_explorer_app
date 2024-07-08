//
//  AttractionsService.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 23.06.2024.
//

import Foundation
import MapKit

protocol AttractionsServiceProtocol {
    func fetchAttractions() async throws -> [Attraction]
}

class AttractionsService: AttractionsServiceProtocol {
    private let baseURL = URL(string: "https://c490973c-0f21-4e71-866e-f8e4c353507b-00-3j1hu3pc5bvs1.kirk.replit.dev/api/attractions")!
    private let imagesRep = ImagesRepository()
    
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
    
    enum ServiceError: Error {
        case noData
        case invalidResponse
        case serverError(Int)
    }
    
    func fetchAttractions() async throws -> [Attraction] {
        let (data, response) = try await URLSession.shared.data(from: baseURL)
        
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

        do {
            var attractions = try JSONDecoder().decode([AttractionWrapper].self, from: data)
            var responseAttractions: [Attraction] = []
            
            for attraction in attractions {
                if !attraction.categories.isEmpty {
                    var newAttraction = Attraction(
                        id: attraction.id,
                        name: attraction.name,
                        shortDescription: attraction.shortDescription,
                        fullDescription: attraction.fullDescription,
                        address: attraction.address,
                        coordinates: CLLocationCoordinate2D(
                            latitude: attraction.latitude,
                            longitude: attraction.longitude
                        ),
                        images: [],
                        categories: attraction.categories.compactMap { Attraction.Category(rawValue: $0) }
                    )
                    responseAttractions.append(newAttraction)
                }
            }
            
            if attractions.isEmpty {
                throw NSError(domain: "AttractionsService", code: 1, userInfo: [NSLocalizedDescriptionKey: "No attractions available."])
            }
            
            return responseAttractions
        } catch let error {
            if let decodingError = error as? DecodingError {
                throw NSError(domain: "AttractionsService", code: 1, userInfo: [NSLocalizedDescriptionKey: "Decoding error: \(decodingError.localizedDescription)"])
            } else {
                throw error
            }
        }
    }
}
