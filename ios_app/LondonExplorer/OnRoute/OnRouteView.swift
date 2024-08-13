//
//  OnRouteView.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 11.07.2024.
//

import Foundation
import SwiftUI
import MapKit

struct OnRouteView: View {
    @EnvironmentObject var auth: AuthController
    @EnvironmentObject var currentRoute: CurrentRouteManager
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: OnRouteViewModel
    
    init(route: Route, user: User, savedRouteProgress: RouteProgress?) {
        self._viewModel = StateObject(wrappedValue: OnRouteViewModel(route: route, user: user, savedRouteProgress: savedRouteProgress))
    }
    
    init(routeProgress: RouteProgress) {
        self._viewModel = StateObject(wrappedValue: OnRouteViewModel(routeProgress: routeProgress))
    }
    
    var body: some View {
        ZStack {
            if viewModel.isMapLoading {
                ProgressView()
            } else {
                ZStack (alignment: .topLeading) {
                    RouteMap
                    
                    BackButton() {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                    .padding(.leading, 20)
                    
                    OnRouteStatWindow(viewModel: viewModel)
                }
                
                if viewModel.showGreeting {
                    Color.white.opacity(0.1)
                        .edgesIgnoringSafeArea(.all)
                        .background(.ultraThinMaterial)
                    
                    StartRouteGreeting(
                        text: viewModel.greetingText,
                        subText: viewModel.greetingSubText
                    ) {
                        currentRoute.routeProgress = viewModel.routeProgress
                        viewModel.showGreeting = false
                    } actionCancel: {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
        .toolbar(.hidden, for: .tabBar)
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .tabBar)
        .onAppear {
            viewModel.setAuthController(auth)
        }
        .overlay {
            if viewModel.lastStop {
                FinishRoutePopup(isOpen: $viewModel.lastStop) {
                    do {
                        try viewModel.finishRoute()
                        currentRoute.routeProgress = nil
                        self.presentationMode.wrappedValue.dismiss()
                    } catch {
                        viewModel.error = error.localizedDescription
                    }
                }
            }
        }
        .popup(
            isPresented: $viewModel.stopRoute,
            text: "Are you sure you want to stop the route? Your progress won't be saved",
            buttonText: "Stop the route"
        ) {
            currentRoute.routeProgress = nil
            self.presentationMode.wrappedValue.dismiss()
        }
        .sheet(isPresented: Binding<Bool>( get: { !viewModel.error.isEmpty }, set: { _ in })) {
            VStack {
                Text("Error saving progress: \(viewModel.error)")
                    .foregroundColor(Color.redAccent)
            }
        }
    }
    
    private var RouteMap: some View {
        Map (
            position:
                Binding<MapCameraPosition>(
                    get: { MapCameraPosition.region(viewModel.mapRegion) },
                    set: { _ in }
                )
        ) {
            // Current location
            UserAnnotation()
            
            if viewModel.routeProgress.stops == 0 {     // If start the route - path from current location
                
                if let currentCoordinate = viewModel.currentCoordinate {
                    Annotation("Start here", coordinate: currentCoordinate) {   // Current location annotated
                        StartMapAnnotation
                    }
                    .annotationTitles(.hidden)
                }
                
                if let path = viewModel.directionToStart {
                    MapPolyline(path.polyline)          // Path
                        .stroke(Color.redAccent, lineWidth: 5)
                }
                
            } else {    // If next stops - current attraction and path to next stop
                
                Annotation(
                    viewModel.routeProgress.route.stops[viewModel.routeProgress.stops - 1].attraction.name,
                    coordinate: viewModel.routeProgress.route.stops[viewModel.routeProgress.stops - 1].attraction.coordinates
                ) {
                    RouteAttractionAnnotation(
                        image: $viewModel.routeProgress.route.stops[viewModel.routeProgress.stops - 1].attraction.images[0],
                        index: Binding<Int> (
                            get: { viewModel.routeProgress.stops - 1 },
                            set: { _ in }
                        )
                    )
                }
                .annotationTitles(.hidden)
                            
                if viewModel.routeProgress.stops < viewModel.routeProgress.route.stops.count, let route = viewModel.routeProgress.route.pathes[viewModel.routeProgress.stops - 1] {
                    MapPolyline(route.polyline.toMKPolyline())
                        .stroke(Color.redAccent, lineWidth: 3)
                }
                
            }
            
            // Always show next attraction, unless current stop == last stop
            if viewModel.routeProgress.stops < viewModel.routeProgress.route.stops.count {
                Annotation(
                    viewModel.routeProgress.route.stops[viewModel.routeProgress.stops].attraction.name,
                    coordinate: viewModel.routeProgress.route.stops[viewModel.routeProgress.stops].attraction.coordinates
                ) {
                    RouteAttractionAnnotation(image: $viewModel.routeProgress.route.stops[viewModel.routeProgress.stops].attraction.images[0], index: $viewModel.routeProgress.stops)
                }
                .annotationTitles(.hidden)
            }
        }
        .mapControls {
            MapUserLocationButton()
        }
    }
    
    private var StartMapAnnotation: some View {
        ZStack {
            Rectangle()
                .frame(width: 30, height: 30)
                .rotationEffect(.degrees(45))
                .foregroundColor(Color.redAccent)
                .padding(.top, 50)
            
            Circle()
                .frame(width: 65, height: 65)
                .foregroundColor(Color.redAccent)
            
            Text("Start\nhere")
                .foregroundColor(Color.white)
                .font(.system(size: 14, weight: .bold))
        }
        .shadow(radius: 5)
        .padding(.top, -95)
    }
}

#Preview {
    OnRouteView(routeProgress: MockData.RouteProgress[0])
        .environmentObject(AuthController())
        .environmentObject(CurrentRouteManager())
}
