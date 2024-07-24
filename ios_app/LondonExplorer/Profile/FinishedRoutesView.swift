//
//  FinishedRoutesView.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 23.07.2024.
//

import Foundation
import SwiftUI

struct FinishedRoutesView: View {
    @RoutesStorage(key: "LONDON_EXPLORER_FINISHED_ROUTES") var finishedRoutes: [RouteProgress]
//    @State var finishedRoutes: [RouteProgress] = []
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                HStack {
                    SectionHeader(
                        headline: .constant("Your Finished Routes"),
                        subheadline: .constant("See the routes that you've finished")
                    )
                    Spacer()
                }
                
                ForEach(finishedRoutes, id: \.id) { route in
                    if let finished = route.endTime {
                        RouteCard(
                            route: Binding<Route>(
                                get: { route.route },
                                set: { _ in }
                            ),
                            label: CardLabel.completed(finished),
                            size: .M
                        )
                    }
                }
            }
        }
        .toolbar(.visible, for: .tabBar)
        .padding(.all, 20)
//        .onAppear {
//            finishedRoutes = finishedRoutesStorage
//        }
    }
}

#Preview {
    FinishedRoutesView()
}
