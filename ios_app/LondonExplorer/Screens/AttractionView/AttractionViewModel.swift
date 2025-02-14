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
    
    @MainActor
    func toggleAttracation(attraction: Attraction) {
        if let index = stops.firstIndex(where: { $0.attraction == attraction }) {
            self.stops.remove(at: index)
            self.updateStopNumbers()
        } else if stops.count < 10 {
            stops.append(
                Route.RouteStop(
                    stepNo: stops.count + 1,
                    attraction: attraction
                )
            )
        }
    }
    
    @MainActor
    func updateStopNumbers() {
        for index in stops.indices {
            self.stops[index].stepNo = index + 1
        }
    }
}
