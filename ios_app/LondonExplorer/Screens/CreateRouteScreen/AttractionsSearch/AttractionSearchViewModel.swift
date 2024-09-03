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
    @Published var filters: [Category] = []
    @Published var stops: [Route.RouteStop]
    @Published var searchText: String = ""
    @Published var showFilter: Bool = false
    @Published var isLoading: Bool = false
    @Published var error: String? = nil
    
    private let service: AttractionsServiceProtocol = AttractionsService()
    
    init(stops: [Route.RouteStop] = [], useTestData: Bool = false) {
        self.stops = stops
        self.filteredAttractions = []
        if useTestData {
            self.attractions = MockData.Attractions
        } else {
            self.attractions = []
            Task { await self.fetchAttractions() }
        }
    }
    
    @MainActor
    func fetchAttractions() {
        self.isLoading = true
        Task {
            do {
                self.attractions = try await service.fetchAllAttractions()
                self.filteredAttractions = self.attractions
            } catch {
                self.error = error.localizedDescription
                print("Error: \(error)")
            }
            
            self.isLoading = false
        }
    }
    
    func toggleCategoryFilter(category: Category) {
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
