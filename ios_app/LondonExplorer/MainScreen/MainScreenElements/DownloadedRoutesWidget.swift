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
    @Binding var routes: [Route]
    
    var body: some View {
        VStack (spacing: 20) {
            HStack {
                SectionHeader(
                    headline: .constant("Your Favourites"),
                    subheadline: .constant("Try out these routes that you downloaded")
                )
                Spacer()
            }
            
            VStack (spacing: 20) {
                ForEach($routes) { route in
                    if let download = route.downloadDate.wrappedValue {
                        RouteCard(route: route, label: .download(download), size: .M)
                            .environmentObject(auth)
                    }
                }
            }
        }
    }
}


#Preview {
    DownloadedRoutesWidget(
        routes: Binding<[Route]> (
            get: { return MockData.Routes },
            set: { _ in }
        )
    )
    .environmentObject(AuthController())
    .padding()
}
