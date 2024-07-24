//
//  RouteButton.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 20.06.2024.
//

import Foundation
import SwiftUI

enum RouteButton {
    case publish
    case published
    case edit
    case start
    case download
    case deleteDownload
    
    struct RouteButtonDetails {
        var label: String
        var colour: Color
        var text: String
    }
    
    var details: RouteButtonDetails {
        switch self {
        case .publish:
            return RouteButtonDetails(
                label: "arrow.up.circle",
                colour: Color.blueAccent,
                text: "Publish route"
            )
        case .published:
            return RouteButtonDetails(
                label: "",
                colour: Color.clear,
                text: ""
            )
        case .edit:
            return RouteButtonDetails(
                label: "pencil",
                colour: Color.redAccent,
                text: "Edit route"
            )
        case .start:
            return RouteButtonDetails(
                label: "play",
                colour: Color.greenAccent,
                text: "Start the route"
            )
        case .download:
            return RouteButtonDetails(
                label: "",
                colour: Color.clear,
                text: ""
            )
        case .deleteDownload:
            return RouteButtonDetails(
                label: "",
                colour: Color.clear,
                text: ""
            )
        }
    }
    
    @ViewBuilder
    var view: some View {
        VStack(spacing: 7) {
            Image(systemName: self.details.label)
                .icon(size: 30, colour: self.details.colour)
                .fontWeight(.light)
            
            Text(self.details.text)
                .foregroundColor(Color.black)
                .font(.system(size: 14))
        }
        .frame(width: (UIScreen.main.bounds.width - 40) / 3, height: 65)
    }
}
