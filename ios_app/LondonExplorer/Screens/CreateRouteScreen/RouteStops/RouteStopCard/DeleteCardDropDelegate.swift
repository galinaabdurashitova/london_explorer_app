//
//  DeleteCardDropDelegate.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 04.08.2024.
//

import Foundation
import SwiftUI

struct DeleteCardDropDelegate: DropDelegate {
    @Binding var current: Route.RouteStop?
    @ObservedObject var viewModel: RouteStopsViewModel
    
    func dropEntered(info: DropInfo) {
        withAnimation {
            viewModel.deleteIconSize = 35
        }
    }
    
    func performDrop(info: DropInfo) -> Bool {
        guard let current = current else { return false }
        viewModel.deleteStop(stop: current)
        
        viewModel.draggingItem = nil
        
        Task {
            await viewModel.recalculate()
        }
        
        return true
    }
}
