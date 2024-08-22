//
//  RouteStopCardDropDelegate.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 04.08.2024.
//

import Foundation
import SwiftUI

struct RouteStopCardDropDelegate: DropDelegate {
    let item: Route.RouteStop
    @Binding var current: Route.RouteStop?
    @Binding var stops: [Route.RouteStop]
    @ObservedObject var viewModel: RouteStopsViewModel
    
    func dropEntered(info: DropInfo) {
        guard let current = current else { return }
        if current != item, let fromIndex = stops.firstIndex(of: current), let toIndex = stops.firstIndex(of: item) {
            withAnimation {
                stops.move(fromOffsets: IndexSet(integer: fromIndex), toOffset: toIndex > fromIndex ? toIndex + 1 : toIndex)
            }
        }
    }

    func performDrop(info: DropInfo) -> Bool {
        guard let current = current else { return false }
        defer { self.current = nil }
        guard let fromIndex = stops.firstIndex(of: current), let toIndex = stops.firstIndex(of: item) else { return false }
        
        withAnimation {
            stops.move(fromOffsets: IndexSet(integer: fromIndex), toOffset: toIndex > fromIndex ? toIndex + 1 : toIndex)
        }
        
        viewModel.draggingItem = nil
        
        Task {
            await viewModel.recalculate()
        }
        
        return true
    }
}
