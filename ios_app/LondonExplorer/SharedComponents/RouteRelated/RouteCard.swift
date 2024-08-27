//
//  RouteCard.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 30.05.2024.
//

import Foundation
import SwiftUI

struct RouteCard: View {
    @Binding var route: Route
    @State var label: CardLabel
    var size: CardSize
    var navigation: RouteNavigation
    
    public enum CardSize {
        case S
        case M
        case L
    }
    
    init(route: Binding<Route>, label: CardLabel = .empty, size: CardSize = .S, navigation: RouteNavigation? = nil) {
        self._route = route
        self.label = label
        self.size = size
        self.navigation = navigation ?? .info(route.wrappedValue)
    }
    
    var body: some View {
        NavigationLink(value: navigation) {
            VStack (alignment: .leading, spacing: 10) {
                ZStack (alignment: .topTrailing) {
                    Image(uiImage: route.image)
                        .roundedFrame(
                            width: size == .S ? 165 : UIScreen.main.bounds.width - 40,
                            height: size == .L ? UIScreen.main.bounds.width * 0.8 : 165
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
                        .headline(.leading)
                    Text(route.description)
                        .subheadline(.leading)
                }
            }
            .frame(width: size == .S ? 165 : UIScreen.main.bounds.width - 40)
            .foregroundColor(Color.black)
        }
    }
}

#Preview {
    RouteCard(
        route: .constant(MockData.Routes[3]),
        label: .download(Date()),
        size: .L
    )
    .padding()
}
