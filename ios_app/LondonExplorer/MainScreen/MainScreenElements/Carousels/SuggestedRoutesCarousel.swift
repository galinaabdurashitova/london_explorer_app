//
//  SuggestedRoutesCarousel.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 30.05.2024.
//

import Foundation
import SwiftUI

struct SuggestedRoutesCarousel: View {
    @Binding var routes: [Route]
    var lines: Int
    
    init(routes: Binding<[Route]>, lines: Int = 1) {
        self._routes = routes
        if routes.count > 2 * lines {
            self.lines = max(lines, 1)
        } else {
            self.lines = max(routes.count / lines, 1)
        }
    }
    
    var body: some View {
        VStack (spacing: 20) {
            HStack {
                SectionHeader(
                    headline: .constant("Selected for You"),
                    subheadline: .constant("Check out these routes")
                )
                Spacer()
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack (alignment: .top, spacing: 12) {
                    ForEach(0..<numberOfColumns(), id: \.self) { column in
                        VStack (spacing: 20) {
                            ForEach(0..<lines, id: \.self) { row in
                                if let routeIndex = indexForColumnRow(column: column, row: row), routeIndex < routes.count {
                                    RouteCard(
                                        route: $routes[routeIndex],
                                        label: .likes(routes[routeIndex].saves),
                                        navigation: RouteNavigation.info(routes[routeIndex])
                                    )
                                }
                            }
                        }
                    }
                }
            }
            .scrollClipDisabled()
        }
    }
    
    private func numberOfColumns() -> Int {
        return (routes.count + lines - 1) / lines
    }
    
    private func indexForColumnRow(column: Int, row: Int) -> Int? {
        let index = column * lines + row
        return index < routes.count ? index : nil
    }
}


#Preview {
    SuggestedRoutesCarousel(
        routes: .constant(MockData.Routes),
        lines: 3
    )
    .environmentObject(AuthController())
    .padding()
}
