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
    @Published var attraction: Attraction
    
    init(stops: Binding<[Route.RouteStop]>, attraction: Attraction) {
        self._stops = stops
        self.attraction = attraction
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
