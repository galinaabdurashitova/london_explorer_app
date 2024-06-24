//
//  AttractionsService.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 23.06.2024.
//

import Foundation

protocol AttractionsServiceProtocol {
    func fetchAttractions() async throws -> [Attraction]
}

class AttractionsService: AttractionsServiceProtocol {
    private let baseURL = URL(string: "https://your-api-url.com")!
    private let imagesRep = ImagesRepository()
    
    func fetchAttractions() async throws -> [Attraction] {
//        let url = baseURL.appendingPathComponent("attractions")
//        let (data, _) = try await URLSession.shared.data(from: url)
//        return try JSONDecoder().decode([Attraction].self, from: data)
        
        var attractions: [Attraction] = []
        
        for attraction in MockData.Attractions {
            do {
                var newAttraction = attraction
                newAttraction.images = try await imagesRep.getAttractionImages(attraction: attraction)
                attractions.append(newAttraction)
            } catch ImagesRepository.ImageRepositoryError.listingFailed(let message) {
                print("Listing failed for attraction \(attraction.id): \(message)")
            } catch ImagesRepository.ImageRepositoryError.downloadFailed(let itemName, let message) {
                print("Download failed for \(itemName): \(message)")
            } catch {
                print("Unexpected error: \(error.localizedDescription)")
            }
        }
        
        if attractions.isEmpty {
            throw NSError(domain: "AttractionsService", code: 1, userInfo: [NSLocalizedDescriptionKey: "No attractions available."])
        }
        
        return attractions
    }
}
