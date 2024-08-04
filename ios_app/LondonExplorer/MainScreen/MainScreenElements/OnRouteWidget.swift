//
//  OnRouteWidget.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 31.05.2024.
//

import Foundation
import SwiftUI

struct OnRouteWidget: View {
    @EnvironmentObject var auth: AuthController
    @Binding var tabSelection: Int
    @State var routeProgress: RouteProgress?
    
    @CurrentRoutesStorage(key: "LONDON_EXPLORER_CURRENT_ROUTES") var savedRoutesProgress: [RouteProgress]
    
    var body: some View {
        VStack (spacing: 20) {
            if let routeProgress = routeProgress {
                HStack {
                    SectionHeader(
                        headline: .constant("On a Route!")
                    )
                    Spacer()
                }
                
                NavigationLink(value: routeProgress) {
                    RouteProgressView(
                        image: Binding<UIImage>(
                            get: { return routeProgress.route.image },
                            set: { _ in }
                        ),
                        routeName: Binding<String>(
                            get: { return routeProgress.route.name },
                            set: { _ in }
                        ),
                        collectablesDone: Binding<Int>(
                            get: { return routeProgress.collectables },
                            set: { _ in }
                        ),
                        collectablesTotal: Binding<Int>(
                            get: { return routeProgress.route.collectables },
                            set: { _ in }
                        ),
                        stopsDone: Binding<Int>(
                            get: { return routeProgress.stops },
                            set: { _ in }
                        ),
                        stopsTotal: Binding<Int>(
                            get: { return routeProgress.route.stops.count },
                            set: { _ in }
                        )
                    )
                    .onDisappear {
                        if !savedRoutesProgress.isEmpty {
                            if let routeProgress = savedRoutesProgress.first(where: {
                                $0.user.id == auth.profile.id
                            }) {
                                self.routeProgress =  routeProgress
                            }
                        }
                    }
                }
            }
        }
        .onChange(of: savedRoutesProgress) {
            if !savedRoutesProgress.isEmpty {
                if let routeProgress = savedRoutesProgress.first(where: {
                    $0.user.id == auth.profile.id
                }) {
                    self.routeProgress =  routeProgress
                }
            }
        }
        .onChange(of: tabSelection) {
            if !savedRoutesProgress.isEmpty {
                if let routeProgress = savedRoutesProgress.first(where: {
                    $0.user.id == auth.profile.id
                }) {
                    self.routeProgress =  routeProgress
                }
            }
        }
        .onAppear {
            if !savedRoutesProgress.isEmpty {
                if let routeProgress = savedRoutesProgress.first(where: {
                    $0.user.id == auth.profile.id
                }) {
                    self.routeProgress =  routeProgress
                }
            }
        }
    }
}

#Preview {
    OnRouteWidget(tabSelection: .constant(0))
        .environmentObject(AuthController())
        .padding()
}
