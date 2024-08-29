//
//  DownloadedRoutesWidget.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 31.05.2024.
//

import Foundation
import SwiftUI

struct DownloadedRoutesWidget: View {
    @EnvironmentObject var auth: AuthController
    @State var routes: [Route] = []
    private var routeManager = RoutesStorageManager()
    
    var body: some View {
        VStack (spacing: 20) {
            if !routes.isEmpty {
                HStack {
                    SectionHeader(
                        headline: .constant("Your Not Published Routes"),
                        subheadline: .constant("Try out these routes that you created")
                    )
                    Spacer()
                }
                
                VStack (spacing: 20) {
                    ForEach($routes) { route in
                        RouteCard(route: route, label: .created(route.dateCreated.wrappedValue), size: .M)
                    }
                }
            }
        }
        .onAppear {
            self.routes = routeManager.getUserRoute(userId: auth.profile.id)
        }
    }
}


#Preview {
    DownloadedRoutesWidget()
        .environmentObject(AuthController())
        .padding()
}
