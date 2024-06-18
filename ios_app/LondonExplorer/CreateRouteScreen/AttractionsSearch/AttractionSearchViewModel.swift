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
    
    init(stops: [Route.RouteStop] = []) {
        self.attractions = MockData.Attractions
        self.stops = stops
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
