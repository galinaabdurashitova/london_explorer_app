//
//  RouteStopCard.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 09.06.2024.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers

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

struct RouteStopCard: View {
    @ObservedObject var viewModel: RouteStopsViewModel
    @Binding var stop: Route.RouteStop
    @Binding var isDragged: Route.RouteStop?
    
    var body: some View {
        ZStack (alignment: .topLeading) {
            HStack {
                Image(uiImage: stop.attraction.images[0])
                    .roundedFrame(width: 80, height: 80)
                
                VStack (alignment: .leading, spacing: 5) {
                    Text("Stop \(stop.stepNo)")
                        .font(.system(size: 16, weight: .light))
                        .opacity(0.5)
                        .lineLimit(2)
                        .truncationMode(.tail)
                        .multilineTextAlignment(.leading)
                    Text(stop.attraction.name)
                        .font(.system(size: 18, weight: .medium))
                        .kerning(-0.2)
                        .lineLimit(2)
                        .truncationMode(.tail)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
                Image(systemName: isDragged == stop ? "hand.tap.fill" : "quotelevel")
                    .icon(size: 25, colour: Color.black.opacity(0.2))
                    .rotationEffect(isDragged == stop ? .degrees(0) : .degrees(90))
            }
            .padding(.all, 12)
            .background(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 10.0)
                    .stroke(
                        stop.stepNo % 4 == 1 ? Color.redAccent
                        : stop.stepNo % 4 == 2 ? Color.blueAccent
                        : stop.stepNo % 4 == 3 ? Color.yellowAccent
                        : Color.greenAccent,
                        lineWidth: 1.0
                    )
            )
            .cornerRadius(10)
            
            if isDragged != stop {
                Button(action: {
                    viewModel.deleteStop(stop: stop)
                    Task {
                        await viewModel.calculateRoute()
                    }
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .icon(size: 22, colour: Color.redAccent)
                        .background(Color.white)
                        .cornerRadius(100)
                        .padding([.top, .leading], -7)
                }
            }
        }
    }
}

#Preview {
    RouteStopCard(
        viewModel: RouteStopsViewModel(            
            stops: MockData.RouteStops,
            pathes: [nil, nil, nil]
        ),
        stop: Binding<Route.RouteStop> (
            get: { return MockData.RouteStops[0] },
            set: { _ in }
        ),
        isDragged: Binding<Route.RouteStop?> (
            get: { return nil },
            set: { _ in }
        )
    )
    .padding()
}
