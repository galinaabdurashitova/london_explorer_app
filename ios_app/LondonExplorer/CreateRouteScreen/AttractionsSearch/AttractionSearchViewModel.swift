//
//  AttractionSearchViewModel.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 10.06.2024.
//

import Foundation
import SwiftUI

class AttractionSearchViewModel: ObservableObject {
    @Published var attractions: [Attraction]
    @Published var filteredAttractions: [Attraction] = []
    @Published var filters: [Attraction.Category] = []
    @Published var stops: [Route.RouteStop]
    @Published var searchText: String = ""
    @Published var showFilter: Bool = false
    @Published var isLoading: Bool = false
    @Published var error: String? = nil
    
    private let service: AttractionsServiceProtocol = AttractionsService()
    private let imagesRep: ImagesRepository = ImagesRepository()
    
    init(stops: [Route.RouteStop] = []) {
        self.attractions = []
        self.stops = stops
        fetchAttractions()
    }
    
    func fetchAttractions() {
        isLoading = true
        Task {
            do {
                var fetchedAttractions = try await service.fetchAttractions()
                
                for attraction in fetchedAttractions {
                    await fetchAttractionImages(attraction: attraction)
                }
            } catch {
                self.error = error.localizedDescription
                print("Error: \(error)")
            }
            
            isLoading = false
        }
    }
    
    func fetchAttractionImages(attraction: Attraction) async {
        do {
            var newAttraction = attraction
            newAttraction.images = try await imagesRep.getAttractionImages(attractionId: attraction.id)
            attractions.append(newAttraction)
        } catch ImagesRepository.ImageRepositoryError.listingFailed(let message) {
            print("Listing failed for attraction \(attraction.id): \(message)")
        } catch ImagesRepository.ImageRepositoryError.downloadFailed(let itemName, let message) {
            print("Download failed for \(itemName): \(message)")
        } catch {
            print("Unexpected error: \(error.localizedDescription)")
        }
    }
    
    func toggleCategoryFilter(category: Attraction.Category) {
        if !filters.contains(category) {
            filters.append(category)
        } else {
            filters.remove(at: filters.firstIndex(of: category)!)
        }
        filterAttractions()
    }
    
    func filterAttractions() {
        filteredAttractions = attractions
        for category in filters {
            filteredAttractions = filteredAttractions.filter { $0.categories.contains(category) }
        }
    }
    
    func toggleAttracation(attraction: Attraction) {
        if let index = stops.firstIndex(where: { $0.attraction == attraction }) {
            stops.remove(at: index)
            updateStopNumbers()
        } else {
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
}
