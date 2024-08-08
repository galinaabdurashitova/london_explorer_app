//
//  MapRouteView.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 12.06.2024.
//

import Foundation
import SwiftUI
import MapKit

struct MapRouteView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var route: Route
    @State var showSheet: Bool = true
    
    private var collectablesColors: [Color] = [.blueAccent, .yellowAccent, .greenAccent, .redAccent]
    
    init(route: Route) {
        self.route = route
    }
    
    init(stops: [Route.RouteStop], pathes: [CodableMKRoute?], routeName: String = "") {
        self.route = Route(
            dateCreated: Date(),
            userCreated: Route.UserCreated(id: ""),
            name: routeName.isEmpty ? "New Route" : routeName,
            description: "",
            image: stops.count > 0 ? stops[0].attraction.images[0] : UIImage(imageLiteralResourceName: "default"),
            collectables: [],
            stops: stops,
            pathes: pathes
        )
    }
    
    var body: some View {
        ZStack (alignment: .topLeading) {
            Map {
                ForEach(route.stops.indices, id: \.self) { index in
                    if index > 0, let route = route.pathes[index - 1] {
                        MapPolyline(route.polyline.toMKPolyline())
                            .stroke(Color.redAccent, lineWidth: 5)
                    }
                    
                    Annotation(
                        route.stops[index].attraction.name,
                        coordinate: route.stops[index].attraction.coordinates
                    ) {
                        RouteAttractionAnnotation(
                            image: $route.stops[index].attraction.images[0],
                            index: .constant(index)
                        )
                    }
                    .annotationTitles(.hidden)
                    
                }
                
                ForEach(route.collectables.indices, id: \.self) { index in
                    Annotation("Collectable", coordinate: route.collectables[index]) {
                        collactableAnnotation(index: index)
                    }
                }
            }
            .onTapGesture {
                showSheet = true
            }
                        
            BackButton() {
                self.presentationMode.wrappedValue.dismiss()
            }
            .padding(.leading, 20)
        }
        .toolbar(.hidden, for: .tabBar)
        .navigationBarBackButtonHidden(true)
        .sheet(isPresented: $showSheet) {
            RouteSheetContent(route: $route)
                .padding(.horizontal, 20)
                .padding(.vertical, 40)
                .edgesIgnoringSafeArea(.bottom) 
                .gesture(DragGesture().onChanged { _ in })
                .presentationCornerRadius(30)
                .presentationDetents([.medium, .height(120)])
                .presentationBackgroundInteraction(.enabled)
                .interactiveDismissDisabled()
                .presentationContentInteraction(.scrolls)
        }
    }
    
    private func collactableAnnotation(index: Int) -> some View {
        Image("Treasures3DIcon")
            .resizable()
            .scaledToFit()
            .frame(width: 25)
            .shadow(color: Color.white.opacity(0.8), radius: 4)
            .padding(.all, 10)
            .background(collectablesColors[index % 4].opacity(1))
            .cornerRadius(100)
            .shadow(radius: 5)
    }
}

#Preview {
    MapRouteView(route: MockData.Routes[1])
}
