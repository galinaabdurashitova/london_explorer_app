//
//  RouteButton.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 20.06.2024.
//

import Foundation
import SwiftUI

enum RouteButton: Equatable {
    case publish
    case publishing
    case published(Date)
    case edit
    case save(Int)
    case saving
    case saved(Int)
    case start
    case completed(Date)
    case current
    
    struct RouteButtonDetails {
        var label: String
        var colour: Color
        var text: String
        var date: Date?
        var number: Int?
        
        var formattedDate: String? {
            if let date = date {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "d/MM/yy"
                return dateFormatter.string(from: date)
            } else { return nil }
        }
    }
    
    var details: RouteButtonDetails {
        switch self {
        case .publish:
            return RouteButtonDetails(
                label: "arrow.up.circle",
                colour: Color.blueAccent,
                text: "Publish route"
            )
        case .publishing:
            return RouteButtonDetails(
                label: "arrow.up.circle",
                colour: Color.blueAccent,
                text: "Publishing"
            )
        case .published(let date):
            return RouteButtonDetails(
                label: "checkmark.circle",
                colour: Color.blueAccent,
                text: "Published on",
                date: date
            )
        case .edit:
            return RouteButtonDetails(
                label: "pencil",
                colour: Color.redAccent,
                text: "Edit route"
            )
        case .save(let saves):
            return RouteButtonDetails(
                label: "heart",
                colour: Color.redAccent,
                text: "Save",
                number: saves
            )
        case .saving:
            return RouteButtonDetails(
                label: "heart",
                colour: Color.redAccent,
                text: "Saving"
            )
        case .saved(let saves):
            return RouteButtonDetails(
                label: "heart.fill",
                colour: Color.redAccent,
                text: "Delete save",
                number: saves
            )
        case .start:
            return RouteButtonDetails(
                label: "play",
                colour: Color.greenAccent,
                text: "Start the route"
            )
        case .completed(let date):
            return RouteButtonDetails(
                label: "checkmark.gobackward",
                colour: Color.greenAccent,
                text: "Completed on",
                date: date
            )
        case .current:
            return RouteButtonDetails(
                label: "forward",
                colour: Color.greenAccent,
                text: "Continue route"
            )
        }
    }
    
    @ViewBuilder
    var view: some View {
        VStack(spacing: 7) {
            if self == .publishing || self == .saving {
                ProgressView()
                    .frame(height: 30)
            } else {
                Image(systemName: self.details.label)
                    .icon(size: 30, colour: self.details.colour)
                    .fontWeight(.light)
            }
            
            VStack(spacing: 0) {
                if let number = self.details.number {
                    Text(String(number))
                        .foregroundColor(self.details.colour)
                        .font(.system(size: 14, weight: .heavy))
                } else {
                    Text(self.details.text)
                        .foregroundColor(Color.black)
                        .font(.system(size: 14))
                    
                    if let date = self.details.formattedDate {
                        Text(date)
                            .foregroundColor(Color.black)
                            .font(.system(size: 14, weight: .bold))
                    }
                }
            }
        }
        .frame(width: (UIScreen.main.bounds.width - 40) / 3, height: 65)
    }
}

#Preview {
    RouteButton.saving.view
}
