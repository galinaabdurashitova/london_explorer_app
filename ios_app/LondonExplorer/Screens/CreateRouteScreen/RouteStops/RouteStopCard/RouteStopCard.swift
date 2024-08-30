//
//  RouteStopCard.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 09.06.2024.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers

struct RouteStopCard: View {
    @ObservedObject var viewModel: RouteStopsViewModel
    @Binding var stop: Route.RouteStop
    @Binding var isDragged: Route.RouteStop?
    
    var body: some View {
        ZStack (alignment: .topLeading) {
            HStack {
                LoadingImage(url: $stop.attraction.imageURLs[0])
                    .roundedFrameView(width: 80, height: 80)
                
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
            .background(isDragged == nil ? Color.white : stop == isDragged ? Color.white : Color.gray.opacity(0.5))
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
        stop: .constant(MockData.RouteStops[0]),
        isDragged: .constant(nil)
    )
    .padding()
}
