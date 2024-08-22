//
//  AttractionsService.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 23.06.2024.
//

import Foundation
import MapKit

protocol AttractionsServiceProtocol: Service {
    func fetchAttractions() async throws -> [Attraction]
}

class AttractionsService: Service, AttractionsServiceProtocol {
    private let serviceURL = URL(string: "http://attractions-api-gmabdurashitova.replit.app/api/attractions")!
    
    func fetchAttractions() async throws -> [Attraction] {
        let (data, response) = try await URLSession.shared.data(from: serviceURL)

        do {
            try self.checkResponse(response: response, service: "Attractions service", method: "fetchAttractions")
            let attractions = try JSONDecoder().decode([AttractionWrapper].self, from: data)
            var responseAttractions: [Attraction] = []
            
            for attraction in attractions[0..<20] {
                if !attraction.categories.isEmpty {
                    let newAttraction = Attraction(
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
                        finishedImagesDownload: false,
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
