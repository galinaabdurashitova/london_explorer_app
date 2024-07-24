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
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: OnRouteViewModel
    
    init(route: Route) {
        self._viewModel = StateObject(wrappedValue: OnRouteViewModel(route: route))
    }
    
    init(routeProgress: RouteProgress) {
        self._viewModel = StateObject(wrappedValue: OnRouteViewModel(routeProgress: routeProgress))
    }
    
    var body: some View {
        ZStack {
            RouteMap
            
            if viewModel.showGreeting {
                Color.white.opacity(0.1)
                    .edgesIgnoringSafeArea(.all)
                    .background(.ultraThinMaterial)
                
                StartRouteGreeting(            
                    text: viewModel.greetingText,
                    subText: viewModel.greetingSubText
                ) {
                    viewModel.saveRoute()
                    viewModel.showGreeting = false
                } actionCancel: {
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
        }
        .onAppear {
            viewModel.setAuthController(auth)
        }
    }
    
    private var RouteMap: some View {
        ZStack (alignment: .topLeading) {
            Map (
                position:
                    Binding<MapCameraPosition>(
                        get: { MapCameraPosition.region(viewModel.mapRegion) },
                        set: { _ in }
                    )
            ) {
                UserAnnotation()
                
                if viewModel.routeProgress.stops == 0 {
                    if let path = viewModel.directionToStart {
                        MapPolyline(path.polyline)
                            .stroke(Color.redAccent, lineWidth: 5)
                    }
                    
                    if let currentCoordinate = viewModel.currentCoordinate {
                        Annotation(
                            "Start here",
                            coordinate: currentCoordinate
                        ) {
                            StartMapAnnotation
                        }
                    }
                } else {
                    Annotation(
                        viewModel.routeProgress.route.stops[viewModel.routeProgress.stops - 1].attraction.name,
                        coordinate: viewModel.routeProgress.route.stops[viewModel.routeProgress.stops - 1].attraction.coordinates
                    ) {
                        RouteAttractionAnnotation(image: $viewModel.routeProgress.route.stops[viewModel.routeProgress.stops - 1].attraction.images[0], index: Binding<Int> (
                            get: { viewModel.routeProgress.stops - 1 },
                            set: { _ in }
                        ))
                    }
                    .annotationTitles(.hidden)
                    
                    if viewModel.routeProgress.stops < viewModel.routeProgress.route.stops.count, let route = viewModel.routeProgress.route.pathes[viewModel.routeProgress.stops - 1] {
                        MapPolyline(route.polyline.toMKPolyline())
                            .stroke(Color.redAccent, lineWidth: 3)
                    }
                }
                
                
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
            
            BackButton() {
                self.presentationMode.wrappedValue.dismiss()
            }
            .padding(.leading, 20)
            
            StatWindow
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .tabBar)
        .overlay {
            if viewModel.lastStop {
                FinishRoutePopup(isOpen: $viewModel.lastStop) {
                    do {
                        try viewModel.finishRoute()
                        self.presentationMode.wrappedValue.dismiss()
                    } catch {
                        viewModel.error = true
                    }
                }
            }
        }
        .popup(
            isPresented: $viewModel.stopRoute,
            text: "Are you sure you want to stop the route? Your progress won't be saved",
            buttonText: "Stop the route"
        ) {
            viewModel.eraseProgress()
            self.presentationMode.wrappedValue.dismiss()
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
    
    private var StatWindow: some View {
        VStack {
            Spacer()
            
            VStack (spacing: 10) {
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("You're on a route")
                            .subheadline()
                        Text(viewModel.routeProgress.route.name)
                            .screenHeadline()
                    }
                    
                    Spacer()
                    
                    RouteProgressStat(routeProgress: $viewModel.routeProgress, align: .right)
                }
                
                if viewModel.routeProgress.stops < viewModel.routeProgress.route.stops.count {
                    AttractionInfo
                }
                
                HStack (spacing: 0) {
                    RouteClock(routeProgress: $viewModel.routeProgress)
                        .frame(
                            width: ((UIScreen.main.bounds.width - 86) / 4) - 4,
                            height: 60
                        )
                    
                    Buttons
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 25)
            .background(Color.white)
            .cornerRadius(30)
        }
        .padding(.all, 20)
    }
    
    private var AttractionInfo: some View {
        HStack (spacing: 10) {
            Image(uiImage: viewModel.routeProgress.route.stops[viewModel.routeProgress.stops].attraction.images[0])
                .roundedFrame(width: 60, height: 60)
            
            VStack (alignment: .leading, spacing: 0) {
                Text("Aproaching")
                    .font(.system(size: 14))
                Text(viewModel.routeProgress.route.stops[viewModel.routeProgress.stops].attraction.name)
                    .font(.system(size: 20, weight: .medium))
                    .lineLimit(2)
                    .truncationMode(.tail)
            }
            
            Spacer()
            
            NavigationLink(destination: {
                AttractionView(attraction: viewModel.routeProgress.route.stops[viewModel.routeProgress.stops].attraction, allowAdd: false)
            }) {
                HStack (spacing: 5) {
                    Text("Details")
                        .font(.system(size: 15))
                    Image(systemName: "chevron.right")
                }
                .foregroundColor(Color.blueAccent)
            }
        }
    }
    
    private var Buttons: some View {
        HStack (spacing: 2) {
            Button(action: {
                viewModel.changeStop(next: false)
            }) {
                VStack (spacing: 3) {
                    Image(systemName: "backward")
                        .icon(size: 30, colour: Color.blueAccent)
                        .fontWeight(.bold)
                    Text("Previous")
                        .foregroundColor(Color.black)
                        .font(.system(size: 12))
                }
            }
            .frame(width: ((UIScreen.main.bounds.width - 84) / 4) + 5, height: 60)
            
            Button(action: {
                if viewModel.routeProgress.paused {
                    viewModel.stopRoute = true
                } else {
                    viewModel.pause()
                }
            }) {
                VStack (spacing: 3) {
                    Image(systemName: viewModel.routeProgress.paused ? "stop" : "pause.circle")
                        .icon(size: 30, colour: Color.redAccent)
                    Text(viewModel.routeProgress.paused ? "Stop route" : "Pause")
                        .foregroundColor(Color.black)
                        .font(.system(size: 12))
                }
            }
            .frame(width: (UIScreen.main.bounds.width - 84) / 4, height: 60)
            .overlay(
                Rectangle()
                    .frame(width: 1),
                alignment: .leading
            )
            .overlay(
                Rectangle()
                    .frame(width: 1),
                alignment: .trailing
            )
            
            Button(action: {
                if viewModel.routeProgress.paused {
                    viewModel.resume()
                } else {
                    viewModel.changeStop()
                }
            }) {
                VStack (spacing: 3) {
                    Image(systemName: viewModel.routeProgress.paused ? "play" : "forward")
                        .icon(size: 30, colour: Color.greenAccent)
                        .fontWeight(viewModel.routeProgress.paused ? .regular : .bold)
                    Text(viewModel.routeProgress.paused ? "Resume" : "Next")
                        .foregroundColor(Color.black)
                        .font(.system(size: 12))
                }
            }
            .frame(width: (UIScreen.main.bounds.width - 84) / 4, height: 60)
        }
    }
}

#Preview {
    OnRouteView(routeProgress: MockData.RouteProgress[0])
}
