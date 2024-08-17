//
//  OnRouteStatWindow.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 13.08.2024.
//

import Foundation
import SwiftUI

struct OnRouteStatWindow: View {
    @EnvironmentObject var auth: AuthController
    @EnvironmentObject var currentRoute: CurrentRouteManager
    @ObservedObject var viewModel: OnRouteViewModel
    
    var body: some View {
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
                    
                    RouteProgressStat(
                        collectablesDone: Binding<Int> (
                            get: { return viewModel.routeProgress.collectables.count },
                            set: { _ in }
                        ),
                        collectablesTotal: Binding<Int> (
                            get: { return viewModel.routeProgress.route.collectables.count },
                            set: { _ in }
                        ),
                        stopsDone: $viewModel.routeProgress.stops,
                        stopsTotal: Binding<Int> (
                            get: { return viewModel.routeProgress.route.stops.count },
                            set: { _ in }
                        ),
                        align: .right
                    )
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
            .shadow(color: Color.black.opacity(0.1), radius: 5)
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
                AttractionView(attraction: $viewModel.routeProgress.route.stops[viewModel.routeProgress.stops].attraction, allowAdd: false)
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
                viewModel.changeStop(next: false, user: auth.profile)
                currentRoute.routeProgress = viewModel.routeProgress
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
                    currentRoute.routeProgress = viewModel.routeProgress
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
                    currentRoute.routeProgress = viewModel.routeProgress
                } else {
                    viewModel.changeStop(user: auth.profile)
                    currentRoute.routeProgress = viewModel.routeProgress
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
    OnRouteStatWindow(viewModel: OnRouteViewModel(routeProgress: MockData.RouteProgress[0]))
        .environmentObject(CurrentRouteManager())
}
