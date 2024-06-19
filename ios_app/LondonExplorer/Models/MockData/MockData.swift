//
//  MainScreenMockData.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 30.05.2024.
//

import Foundation
import SwiftUI
import MapKit

class MockData {
    public static func calculateRoute (stops: [Route.RouteStop]) async -> [MKRoute?] {
        var pathes: [MKRoute?] = []
        if stops.count > 1 {
            pathes = Array(repeating: nil, count: stops.count-1)
            for index in 1..<stops.count {
                if let calculatedRouteStep = await calculateRouteStep(start: stops[index-1].attraction.coordinates, destination: stops[index].attraction.coordinates) {
                    pathes[index-1] = calculatedRouteStep
                } else {
                    pathes[index-1] = nil
                }
            }
        }
        
        return pathes
    }
        
    public static func calculateRouteStep(start: CLLocationCoordinate2D, destination: CLLocationCoordinate2D) async -> MKRoute? {
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: start))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination))
        request.transportType = .walking

        let directions = MKDirections(request: request)
        do {
            let response = try await directions.calculate()
            if let path = response.routes.first {
                return path
            } else {
                // Debugging: Print out if no routes were found
                print("No routes found")
            }
        } catch {
            print("Error calculating route: \(error.localizedDescription)")
            // Print more detailed error information
            if let error = error as? MKError {
                switch error.code {
                case .placemarkNotFound:
                    print("MKError: Placemark not found")
                case .directionsNotFound:
                    print("MKError: Directions not found")
                case .decodingFailed:
                    print("MKError: Decoding failed")
                case .loadingThrottled:
                    print("MKError: Loading throttled")
                case .serverFailure:
                    print("MKError: Server failure")
                case .unknown:
                    print("MKError: Unknown")
                default:
                    print("MKError: Other error")
                }
            }
        }
        return nil
    }
    
    public static var Routes: [Route] = [
        Route(
            name: "Best London Route",
            description: "Visit all the main sights and see Big Ben following this fantastic route",
            image: UIImage(imageLiteralResourceName: "BigBen"),
            saves: 212,
            collectables: 5,
            stops: RouteStops
            , pathes: [nil, nil, nil]
        ),
        Route(
            name: "London Secrets",
            description: "Another description but shorter",
            image: UIImage(imageLiteralResourceName: "Museum"),
            saves: 52,
            collectables: 7,
            stops: RouteStops
            , pathes: [nil, nil, nil]
        ),
        Route(
            name: "Some Route Some Route Some Route",
            description: "Visit all the main sights and see Big Ben following this fantastic route",
            image: UIImage(imageLiteralResourceName: "LondonStreet"),
            saves: 103,
            collectables: 5,
            stops: RouteStops
            , pathes: [nil, nil, nil]
        ),
        Route(
            name: "Best London Route",
            description: "Visit all the main sights and see Big Ben following this fantastic route",
            image: UIImage(imageLiteralResourceName: "BigBen"),
            saves: 212,
            collectables: 5,
            downloadDate: Date(),
            stops: RouteStops
            , pathes: [nil, nil, nil]
        ),
        Route(
            name: "London Secrets",
            description: "Another description but shorter",
            image: UIImage(imageLiteralResourceName: "Museum"),
            saves: 52,
            collectables: 5,
            stops: RouteStops
            , pathes: [nil, nil, nil]
        )//,
//        Route(
//            name: "Some Route",
//            description: "Visit all the main sights and see Big Ben following this fantastic route",
//            image: UIImage(imageLiteralResourceName: "LondonStreet"),
//            saves: 103
//        )
    ]
    
    public static var FriendsFeed: [FriendUpdate] = [
        FriendUpdate(
            friend: Users[0],
            caption: "Anna completed a route",
            subCaption: "Best London route",
            date: Date(),
            update: FriendUpdate.UpdateType.routeCompleted
        ),
        FriendUpdate(
            friend: Users[1],
            caption: "Mary achieved a medal",
            subCaption: "for 100 collectables",
            date: Date(),
            update: FriendUpdate.UpdateType.collectables100
        ),
        FriendUpdate(
            friend: Users[0],
            caption: "Anna completed a route",
            subCaption: "Best London route",
            date: Date(),
            update: FriendUpdate.UpdateType.routeCompleted
        )
    ]
    
    public static var Users: [User] = [
        User(userId: "1", name: "Anna", image: Image("Anna")),
        User(userId: "2", name: "Mary", image: Image("Mary"))
    ]
    
    public static var RouteProgress: [RouteProgress] = [
        LondonExplorer.RouteProgress(route: Routes[2], collectables: 3, stops: 2),
        LondonExplorer.RouteProgress(route: Routes[2], collectables: 3, stops: 3, user: Users[0]),
        LondonExplorer.RouteProgress(route: Routes[1], collectables: 2, stops: 1, user: Users[1])
    ]
    
    public static var Attractions: [Attraction] = [
        Attraction(
            name: "Big Ben & Houses of Parliament",
            shortDescription: "Iconic Clock Tower & Political Heart",
            fullDescription: "Hear the world-famous chime and delve into British democracy. Witness the grand clock tower of Big Ben, a neo-gothic masterpiece that has become synonymous with London. Hear the bongs of the Great Bell echo across the city, a sound that has marked the hour for over 150 years. Step inside the Houses of Parliament, the seat of the British government, and witness the chambers where crucial decisions are made. Take a guided tour to peek into the hallowed halls where Prime Ministers debate and pass laws. Explore the rich history of British democracy, from the signing of the Magna Carta to the evolution of modern politics. Big Ben and the Houses of Parliament stand as a testament to the enduring spirit of British democracy.",
            address: "London SW1A 0AA",
            coordinates: CLLocationCoordinate2D(latitude: 51.4991509, longitude: -0.1252128),
            images: [
                UIImage(imageLiteralResourceName: "BigBen1"),
                UIImage(imageLiteralResourceName: "BigBen2"),
                UIImage(imageLiteralResourceName: "BigBen3"),
                UIImage(imageLiteralResourceName: "BigBen4"),
                UIImage(imageLiteralResourceName: "BigBen5")
            ],
            categories: [
                .historical,
                .mustsee,
                .cultural,
                .unique
            ]
        ),
        Attraction(
            name: "Buckingham Palace",
            shortDescription: "Witness Changing of the Guard",
            fullDescription: "Marvel at the iconic ceremony and royal residence. Witness the pomp and pageantry of the Changing of the Guard ceremony, a centuries-old tradition dating back to 1660. Watch the impeccably dressed soldiers in their colourful uniforms march to the rhythmic beat of military music. Explore the State Rooms, lavishly decorated with priceless art and opulent furniture. Walk the halls where kings and queens have resided for centuries and imagine the grand events unfolding within these walls. Buckingham Palace is a living symbol of the British monarchy, offering a glimpse into the grandeur and tradition of royal life.\n\nBuckingham Palace isn’t just a grand building. It’s a working royal residence! The Queen often holds important meetings and receptions here, and the Royal Standard is not flown during her absence. Be sure to check the official website before your visit to see if the flag is flying and if the State Rooms are open to the public.",
            address: "London SW1A 1AA", 
            coordinates: CLLocationCoordinate2D(latitude: 51.5013481, longitude: -0.1419304),
            images: [
                UIImage(imageLiteralResourceName: "BuckinghamPalace1"),
                UIImage(imageLiteralResourceName: "BuckinghamPalace2"),
                UIImage(imageLiteralResourceName: "BuckinghamPalace3"),
                UIImage(imageLiteralResourceName: "BuckinghamPalace4"),
                UIImage(imageLiteralResourceName: "BuckinghamPalace5")
            ],
            categories: [
                .historical,
                .mustsee
            ]
        ),
        Attraction(
            name: "British Museum",
            shortDescription: "Treasures from Around the Globe",
            fullDescription: "Journey through history with mummies, the Rosetta Stone, and more. Explore a vast collection of antiquities from around the world, spanning continents and civilizations. Decipher the mysteries of the Rosetta Stone, marvel at the awe-inspiring Egyptian mummies, and come face-to-face with the Parthenon sculptures.\n\nThe British Museum is a treasure trove of world history, housing over 8 million objects from every corner of the globe. Get lost amongst ancient Egyptian artifacts, explore the grandeur of the Roman Empire, and marvel at the intricate artistry of Asian cultures. The Rosetta Stone, a key to unlocking hieroglyphics, is a must-see, as are the awe-inspiring mummies from ancient Egypt. A visit to the British Museum is a journey through time, offering a glimpse into the rich tapestry of human history.",
            address: "Great Russell St, London WC1B 3DG",
            coordinates: CLLocationCoordinate2D(latitude: 51.5194155, longitude: -0.1269882),
            images: [
                UIImage(imageLiteralResourceName: "BritishMuseum1"),
                UIImage(imageLiteralResourceName: "BritishMuseum2"),
                UIImage(imageLiteralResourceName: "BritishMuseum3")
            ],
            categories: [
                .museums,
                .mustsee,
                .cultural
            ]
        ),
        Attraction(
            name: "Tower of London",
            shortDescription: "Explore a Dark and Storied Past",
            fullDescription: "Uncover a thousand years of history within these imposing walls. Journey through time, from a medieval fortress built by William the Conqueror in 1070 to a royal palace that housed legendary figures like Henry VIII and Anne Boleyn.\n\nDescend into the depths of the infamous prison, where countless historical figures, including Sir Thomas More and Lady Jane Grey, met their demise. Explore the Crown Jewels, a dazzling collection of priceless gems and artefacts used for coronations for centuries. Marvel at the beauty of the Imperial State Crown, adorned with over 2,800 diamonds, and imagine the power and prestige it represents.\n\nThe Tower of London is a captivating blend of architectural marvels, historical significance, and chilling tales, offering a unique glimpse into London’s turbulent past.",
            address: "London EC3N 4AB",
            coordinates: CLLocationCoordinate2D(latitude: 51.5081266, longitude: -0.0760809),
            images: [
                UIImage(imageLiteralResourceName: "Tower1")
            ],
            categories: [
                .historical,
                .mustsee,
                .unique
            ]
        )
    ]
    
    
    public static var RouteStops: [Route.RouteStop] = [
        Route.RouteStop(stepNo: 1, attraction: Attractions[0]),
        Route.RouteStop(stepNo: 2, attraction: Attractions[1]),
        Route.RouteStop(stepNo: 3, attraction: Attractions[2]),
        Route.RouteStop(stepNo: 4, attraction: Attractions[3])
    ]
}
