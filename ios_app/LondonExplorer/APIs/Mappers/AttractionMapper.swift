//
//  AttractionMapper.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 29.08.2024.
//

import Foundation
import MapKit

class AttractionMapper {
    func mapToAttraction(from dto: AttractionWrapper) async throws -> Attraction {
        let imageURLs = try await ImagesRepository.shared.getAttractionImagesURL(attractionId: dto.id)
        
        let attraction = Attraction(
            id: dto.id,
            name: dto.name,
            shortDescription: dto.shortDescription,
            fullDescription: dto.fullDescription,
            address: dto.address,
            coordinates: CLLocationCoordinate2D(
                latitude: dto.latitude,
                longitude: dto.longitude
            ),
            imageURLs: imageURLs,
            categories: dto.categories.compactMap { Category(rawValue: $0) }
        )
        
        return attraction
    }
}
