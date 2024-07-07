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
    private let baseURL = URL(string: "http://localhost:8080/api/attractions")!
    private let imagesRep = ImagesRepository()
    
    func fetchAttractions() async throws -> [Attraction] {
        //let url = baseURL.appendingPathComponent("")
        let (data, response) = try await URLSession.shared.data(from: baseURL)
        
//        guard let response = response as? HTTPURLResponse else {
//            throw APIError.server
//        }
//
//        switch response.statusCode {
//            case 400 ..< 500: throw APIError.client
//            case 500 ..< 600: throw APIError.server
//            default: break
//        }
//        
//        var attr = try JSONDecoder().decode(Array<Any>.self, from: data)
//        
//        for d in attr {
//            print(d as? [String: AnyObject] ?? [:])
//        }
//        
        var attractions = try JSONDecoder().decode([AttractionWrapper].self, from: data)
        var responseAttractions: [Attraction] = []
        
        for attraction in attractions {
            do {
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
                    images: try await imagesRep.getAttractionImages(attractionId: attraction.id),
                    categories: attraction.categories.compactMap { Attraction.Category(rawValue: $0) }
                )
//                newAttraction.images = try await imagesRep.getAttractionImages(attraction: attraction)
                responseAttractions.append(newAttraction)
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
        
        return responseAttractions
    }
}
