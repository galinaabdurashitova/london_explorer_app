//
//  YourRoutesCarousel.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 08.06.2024.
//

import Foundation
import SwiftUI

// Not used in the final version
struct YourRoutesCarousel: View {
    @Binding var routes: [Route]
    @Binding var path: NavigationPath
    
    var body: some View {
        VStack (spacing: 20) {
            HStack {
                SectionHeader(
                    headline: .constant("Your Routes"),
                    subheadline: .constant("Routes created by you")
                )
                Spacer()
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack (alignment: .top, spacing: 12) {
                    CreateRouteCard(path: $path)
                    
                    ForEach($routes) { route in
                        RouteCard(route: route, label: .likes(route.saves.count))
                    }
                }
            }
            .scrollClipDisabled()
        }
    }
}

#Preview {
    YourRoutesCarousel(
        routes: .constant(MockData.Routes),
        path: .constant(NavigationPath())
    )
    .environmentObject(NetworkMonitor())
    .environmentObject(AuthController())
    .padding()
}
