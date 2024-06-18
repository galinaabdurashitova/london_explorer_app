//
//  YourRoutesCarousel.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 08.06.2024.
//

import Foundation
import SwiftUI

struct YourRoutesCarousel: View {
    @EnvironmentObject var networkMonitor: NetworkMonitor
    @Binding var routes: [Route]
    
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
                    CreateRouteCard()
                        .environmentObject(NetworkMonitor())
                    
                    ForEach($routes) { route in
                        RouteCard(route: route, label: .likes(route.saves.wrappedValue))
                    }
                }
            }
            .scrollClipDisabled()
        }
    }
}

#Preview {
    YourRoutesCarousel(
        routes: Binding<[Route]> (
            get: { return MockData.Routes },
            set: { _ in }
        )
    )
    .environmentObject(NetworkMonitor())
    .padding()
}
