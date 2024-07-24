//
//  EditRouteViewModel.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 23.06.2024.
//

import Foundation
import SwiftUI

class EditRouteViewModel: ObservableObject {
    @Binding var route: Route
    @Binding var isSheetPresented: Bool
    @Published var name: String
    @Published var description: String
    @RoutesStorage(key: "LONDON_EXPLORER_ROUTES") var savedRoutes: [Route]
    
    private var routesService = RoutesService()
    
    init(route: Binding<Route>, isSheetPresented: Binding<Bool>) {
        self._route = route
        self._isSheetPresented = isSheetPresented
        self.name = route.wrappedValue.name
        self.description = route.wrappedValue.description
    }
    
    func saveEditRoute() {
        Task {
            do {
                try await routesService.updateRoute(updatedRoute: route)
                isSheetPresented = false
            } catch {
                
            }
        }
    }
    
    func cancelEditRoute() {
        isSheetPresented = false
        name = route.name
        description = route.description
    }
}
