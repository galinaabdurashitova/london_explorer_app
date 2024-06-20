//
//  RouteCard.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 30.05.2024.
//

import Foundation
import SwiftUI

struct RouteCard: View {
    public enum CardSize {
        case S
        case M
        case L
    }
    
    @Binding var route: Route
    @State var label: CardLabel = .empty
    var size: CardSize = .S
    
    var body: some View {
        NavigationLink(destination: {
            RouteView(route: route)
        }) {
            VStack (alignment: .leading, spacing: 10) {
                ZStack (alignment: .topTrailing) {
                    Image(uiImage: route.image)
                        .roundedHeightFrame(
                            height: size == .L ? UIScreen.main.bounds.width * 0.8 : 156
                        )
                    
                    label.view
                        .padding(.all, 6.0)
                        .background(Color.lightBlue)
                        .opacity(0.7)
                        .cornerRadius(16.0)
                        .padding(.all, 7.0)
                }
                
                VStack (alignment: .leading, spacing: 5) {
                    Text(route.name)
                        .headline()
                    Text(route.description)
                        .subheadline()
                }
            }
            .frame(width: size == .S ? 156 : UIScreen.main.bounds.width - 40)
            .foregroundColor(Color.black)
        }
    }
}

#Preview {
    RouteCard(
        route: Binding<Route> (
            get: { return MockData.Routes[3] },
            set: { _ in }
        ),
        label: .download(Date()),
        size: .L
    )
    .padding()
}
