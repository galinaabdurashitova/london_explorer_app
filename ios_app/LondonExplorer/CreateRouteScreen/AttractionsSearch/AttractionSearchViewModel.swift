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
    @Published var filteredAttractions: [Attraction]
    @Published var filters: [Attraction.Category] = []
    @Published var stops: [Route.RouteStop]
    @Published var searchText: String = ""
    @Published var showFilter: Bool = false
    @Published var isLoading: Bool = false
    @Published var error: String? = nil
    
    private let service: AttractionsServiceProtocol = AttractionsService()
    private let imagesRep: ImagesRepository = ImagesRepository()
    
    init(stops: [Route.RouteStop] = [], useTestData: Bool = false) {
        self.stops = stops
        self.filteredAttractions = []
        if useTestData {
            self.attractions = MockData.Attractions
        } else {
            self.attractions = []
            self.fetchAttractions()
        }
    }
    
    func fetchAttractions() {
        self.isLoading = true
        Task {
            do {
                let fetchedAttractions = try await service.fetchAttractions()
                
                for attraction in fetchedAttractions {
                    var newAttraction = attraction
                    await fetchAttractionImage(attraction: &newAttraction)
                    if !newAttraction.images.isEmpty {
                        DispatchQueue.main.async {
                            self.attractions.append(newAttraction)
                        }
                    }
                }
                
                DispatchQueue.main.async {
                    self.filteredAttractions = self.attractions
                }
            } catch {
                DispatchQueue.main.async { self.error = error.localizedDescription }
                print("Error: \(error)")
            }
            
            DispatchQueue.main.async {
                self.isLoading = false
            }
        }
    }
    
    func fetchAttractionImage(attraction: inout Attraction) async {
        do {
            let images = try await imagesRep.getAttractionImage(attractionId: attraction.id)
            attraction.images = images
        } catch ImagesRepository.ImageRepositoryError.listingFailed(let message) {
            print("Listing failed for attraction \(attraction.id): \(message)")
        } catch ImagesRepository.ImageRepositoryError.downloadFailed(let itemName, let message) {
            print("Download failed for \(itemName): \(message)")
        } catch {
            print("Unexpected error: \(error.localizedDescription)")
        }
    }
    
    func fetchAttractionImages(attraction: inout Attraction) async {
        do {
            let images = try await imagesRep.getAttractionImages(attractionId: attraction.id)
            attraction.images = images
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
        var tempAttractions = attractions
        
        if !filters.isEmpty {
            for category in filters {
                tempAttractions = filteredAttractions.filter { $0.categories.contains(category) }
            }
        }
        
        if !searchText.isEmpty {
            tempAttractions = tempAttractions.filter { attraction in
                attraction.name.lowercased().contains(searchText.lowercased()) ||
                attraction.shortDescription.lowercased().contains(searchText.lowercased())
            }
        }
        
        filteredAttractions = tempAttractions
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
}
