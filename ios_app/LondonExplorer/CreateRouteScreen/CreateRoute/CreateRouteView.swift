//
//  CreateRouteView.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 07.06.2024.
//

import Foundation
import SwiftUI

struct CreateRouteView: View {
    @EnvironmentObject var networkMonitor: NetworkMonitor
    @State var routes: [Route] = MockData.Routes
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack (spacing: 25) {
                    HStack {
                        ScreenHeader(
                            headline: .constant("New Route"),
                            subheadline: .constant("You can create new route or choose from the existing")
                        )
                        Spacer()
                    }
                    
                    YourRoutesCarousel(routes: $routes)
                    
                    if networkMonitor.isConnected {
                        SuggestedRoutesCarousel(routes: $routes)
                    } else {
                        DownloadedRoutesWidget(routes: $routes)
                    }
                }
                .padding(.all, 20)
            }
        }
    }
}

#Preview {
    CreateRouteView()
        .environmentObject(NetworkMonitor())
}
