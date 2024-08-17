//
//  Collectable.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 07.08.2024.
//

import Foundation
import SwiftUI

enum Collectable: String, Codable, Hashable, CaseIterable {
    case bus = "Double-decker"
    case guardian = "Royal guardian"
    case telephoneBox = "Telephone Box"
    case riverBoat = "Thames River Boat"
    case postBox = "Red Post Box"
    case bigBen = "Big Ben"
    case taxi = "Black Taxi Cab"
    case lamp = "London Street Lamp"
    case tea = "Tea Pot and Cup of Tea"
    case fishAndChips = "Fish and Chips"
    case pint = "Pint Glass"
    case policeHelmet = "British Police Helmet"
    case towerBridge = "Tower Bridge"
    case pub = "Pub"
    case cricketBat = "Cricket Bat"
    case umbrella = "Umbrella"
    case pigeon = "London Pigeon"
    case bulldog = "British Bulldog"
    case newspaper = "Daily Newspaper"
    case lions = "Trafalgar Square Lions"
    
    var image: Image {
        switch self {
        case .bus:
            return Image("1-Double-Decker")
        case .guardian:
            return Image("2-Guardian")
        case .telephoneBox:
            return Image("3-Telephone-Box")
        case .riverBoat:
            return Image("4-Thames-River-Boat")
        case .postBox:
            return Image("5-Red-Post-Box")
        case .bigBen:
            return Image("6-Big-Ben")
        case .taxi:
            return Image("7-Black-Taxi-Cab")
        case .lamp:
            return Image("8-Street-Lamp")
        case .tea:
            return Image("9-Cup-of-tea")
        case .fishAndChips:
            return Image("10-Fish-and-Chips")
        case .pint:
            return Image("11-pint2")
        case .policeHelmet:
            return Image("12-Police-helmet")
        case .towerBridge:
            return Image("13-Tower-Bridge")
        case .pub:
            return Image("14-Pub")
        case .cricketBat:
            return Image("15-Cricket-Bat")
        case .umbrella:
            return Image("16-Umbrella")
        case .pigeon:
            return Image("17-Pigeon")
        case .bulldog:
            return Image("18-Bulldog")
        case .newspaper:
            return Image("19-Newspaper")
        case .lions:
            return Image("20-Trafalgar-Square")
        }
    }
}

