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
    @EnvironmentObject var auth: AuthController
    @State var routes: [Route] = MockData.Routes
    @Binding var tabSelection: Int
    @State var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            ScrollView(showsIndicators: false) {
                VStack (spacing: 25) {
                    HStack {
                        ScreenHeader(
                            headline: .constant("New Route"),
                            subheadline: .constant("You can create new route or choose from the existing")
                        )
                        Spacer()
                    }
                    
                    YourRoutesCarousel(routes: $routes, tabSelection: $tabSelection, path: $path)
                        .environmentObject(auth)
                    
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
    CreateRouteView(tabSelection: .constant(2))
        .environmentObject(NetworkMonitor())
        .environmentObject(AuthController())
}
