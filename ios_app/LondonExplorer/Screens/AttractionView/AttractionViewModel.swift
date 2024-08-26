//
//  AttractionViewModel.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 21.07.2024.
//

import Foundation
import SwiftUI

class AttractionViewModel: ObservableObject {
    @Binding var stops: [Route.RouteStop]
    @Binding var attraction: Attraction
    
    init(stops: Binding<[Route.RouteStop]>, attraction: Binding<Attraction>) {
        self._stops = stops
        self._attraction = attraction
    }
    
    func toggleAttracation(attraction: Attraction) {
        if let index = stops.firstIndex(where: { $0.attraction == attraction }) {
            stops.remove(at: index)
            updateStopNumbers()
        } else if stops.count < 10 {
            stops.append(
                Route.RouteStop(
                    stepNo: stops.count + 1,
                    attraction: attraction
                )
            )
        }
    }
    
    func updateStopNumbers() {
        for index in stops.indices {
            stops[index].stepNo = index + 1
        }
    }
    
    @MainActor
    func fetchAttractionImages() async {
        if !attraction.finishedImagesDownload {
            do {
                let images = try await ImagesRepository.shared.getAttractionImages(attractionId: attraction.id, reload: true)
                
                self.attraction.images = images
                self.attraction.finishedImagesDownload = true
            } catch ImagesRepository.ImageRepositoryError.listingFailed(let message) {
                print("Listing failed for attraction \(attraction.id): \(message)")
            } catch ImagesRepository.ImageRepositoryError.downloadFailed(let itemName, let message) {
                print("Download failed for \(itemName): \(message)")
            } catch {
                print("Unexpected error: \(error.localizedDescription)")
            }
        }
    }
}
