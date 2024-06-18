//
//  RouteStopCard.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 09.06.2024.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers

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
        
        Task {
            await viewModel.recalculate()
        }
        
        return true
    }
}

struct RouteStopCard: View {
    @ObservedObject var viewModel: RouteStopsViewModel
    @Binding var stop: Route.RouteStop
    
    var body: some View {
        ZStack (alignment: .topLeading) {
            HStack {
                stop.attraction.images[0]
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 80)
                    .cornerRadius(8)
                
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
                Image(systemName: "quotelevel")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 25)
                    .opacity(0.2)
                    .rotationEffect(.degrees(90))
            }
            .padding(.all, 12)
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
            
            Button(action: {
                viewModel.deleteStop(stop: stop)
            }) {
                Image(systemName: "xmark.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 22)
                    .background(Color.white)
                    .foregroundColor(Color.redAccent)
                    .cornerRadius(100)
                    .padding([.top, .leading], -7)
            }
        }
    }
}

#Preview {
    RouteStopCard(
        viewModel: RouteStopsViewModel(),
        stop: Binding<Route.RouteStop> (
            get: { return MockData.RouteStops[0] },
            set: { _ in }
        )
    )
    .padding()
}
