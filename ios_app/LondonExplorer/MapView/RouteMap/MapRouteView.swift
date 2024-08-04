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
            collectables: 0,
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
}

#Preview {
    MapRouteView(route: MockData.Routes[0])
}
