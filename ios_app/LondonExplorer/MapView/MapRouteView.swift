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
//    @State var route: Route
    @State var routeName: String
    @State var stops: [Route.RouteStop]
    @State var pathes: [CodableMKRoute?]
    @State var showSheet: Bool = true
//    @State var useTestData: Bool = false
    
    // Function used for test view separately - for the preview
//    func buildRoute() async {
//        route.pathes = await MockData.calculateRoute(stops: route.stops).compactMap {
//            $0 != nil ? CodableMKRoute(from: $0!) : nil
//        }
//    }
    
    init(route: Route) {
        self.routeName = route.name
        self.stops = route.stops
        self.pathes = route.pathes
    }
    
    init(stops: [Route.RouteStop], pathes: [CodableMKRoute?]) {
        self.routeName = "New Route"
        self.stops = stops
        self.pathes = pathes
    }
    
    var body: some View {
        ZStack (alignment: .topLeading) {
            Map(selection: .constant(MKMapItem())) {
                ForEach(stops.indices, id: \.self) { index in
                    if index > 0, let route = pathes[index - 1] {
                        MapPolyline(route.polyline.toMKPolyline())
                            .stroke(Color.redAccent, lineWidth: 5)
                    }
                    
                    Annotation(
                        stops[index].attraction.name,
                        coordinate: stops[index].attraction.coordinates
                    ) {
                        RouteAttractionAnnotation(index: index)
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
        .navigationBarBackButtonHidden(true)
        .sheet(isPresented: $showSheet) {
//            RouteSheetContent(route: $route)
            RouteSheetContent(routeName: $routeName, stops: $stops, pathes: $pathes)
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
//        .onAppear {
//            if useTestData {
//                Task {
//                    await buildRoute()
//                }
//            }
//        }
    }
    
    private func RouteAttractionAnnotation(index: Int) -> some View {
        ZStack {
            Circle()
                .frame(width: 65, height: 65)
                .foregroundColor(Color.redAccent)
            
            Rectangle()
                .frame(width: 30, height: 30)
                .rotationEffect(.degrees(45))
                .foregroundColor(Color.redAccent)
                .padding(.top, 50)
            
            Image(uiImage: stops[index].attraction.images[0])
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 60, height: 60)
                .cornerRadius(100)
            
            Text(String(index + 1))
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(Color.white)
                .frame(width: 25, height: 25)
                .background(Color.redAccent)
                .cornerRadius(100)
                .padding(.top, -35)
                .padding(.leading, 48)
        }
        .shadow(radius: 5)
        .padding(.top, -95)
    }
}

//#Preview {
//    MapRouteView(
//        route: MockData.Routes[0]//,
////        useTestData: true
//    )
//}
