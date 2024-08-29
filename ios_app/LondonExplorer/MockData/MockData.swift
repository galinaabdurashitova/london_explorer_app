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
    public static var Routes: [Route] = [
        Route(
            id: "1",
            dateCreated: Calendar.current.date(from: DateComponents(year: 2024, month: 1, day: 1, hour: 12, minute: 0))!,
            userCreated: "1",
            name: "Best London Route",
            description: "Visit all the main sights and see Big Ben following this fantastic route",
            saves: ["1", "2", "3", "4", "5"],
            collectables: [
                Route.RouteCollectable(
                    location: CLLocationCoordinate2D(latitude: 51.51606596804756, longitude: -0.1207032745398544),
                    type: Collectable.bigBen
                ),
                Route.RouteCollectable(
                    location: CLLocationCoordinate2D(latitude: 51.5154046934602, longitude:  -0.12538290000351276),
                    type: Collectable.bulldog
                ),
                Route.RouteCollectable(
                    location: CLLocationCoordinate2D(latitude: 51.501324012606865, longitude: -0.12401221244365833),
                    type: Collectable.bus
                ),
                Route.RouteCollectable(
                    location: CLLocationCoordinate2D(latitude: 51.51968000393714, longitude: -0.12275441790985948),
                    type: Collectable.cricketBat
                )
            ],
            stops: RouteStops,
            pathes: [nil, nil, nil]
        ),
        Route(
            dateCreated: Calendar.current.date(from: DateComponents(year: 2024, month: 1, day: 1, hour: 12, minute: 0))!,
            userCreated: "2",
            name: "London Secrets",
            description: "Another description but shorter",
            saves: ["1", "2", "3", "4", "5", "1", "2", "3"],
            collectables: [
                Route.RouteCollectable(
                    location: CLLocationCoordinate2D(latitude: 51.498762278960335, longitude: -0.1263361765911308),
                    type: Collectable.fishAndChips
                ),
                Route.RouteCollectable(
                    location: CLLocationCoordinate2D(latitude: 51.50937123247818, longitude: -0.12743665028792597),
                    type: Collectable.guardian
                ),
                Route.RouteCollectable(
                    location: CLLocationCoordinate2D(latitude: 51.51919253774111, longitude: -0.13056578773788566),
                    type: Collectable.lamp
                ),
                Route.RouteCollectable(
                    location: CLLocationCoordinate2D(latitude: 51.516036179656275, longitude: -0.12470830890801224),
                    type: Collectable.lions
                ),
                Route.RouteCollectable(
                    location: CLLocationCoordinate2D(latitude: 51.51876242989569, longitude: -0.10812954588346282),
                    type: Collectable.newspaper
                )
            ],
            stops: RouteStops
            , pathes: [nil, nil, nil]
        ),
        Route(
            dateCreated: Calendar.current.date(from: DateComponents(year: 2024, month: 1, day: 1, hour: 12, minute: 0))!,
            userCreated: "1",
            name: "Some Route Some Route Some Route",
            description: "Visit all the main sights and see Big Ben following this fantastic route",
            saves: ["1", "2", "3", "4"],
            collectables: [
                Route.RouteCollectable(
                    location: CLLocationCoordinate2D(latitude: 51.498762278960335, longitude: -0.1263361765911308),
                    type: Collectable.fishAndChips
                ),
                Route.RouteCollectable(
                    location: CLLocationCoordinate2D(latitude: 51.50937123247818, longitude: -0.12743665028792597),
                    type: Collectable.guardian
                ),
                Route.RouteCollectable(
                    location: CLLocationCoordinate2D(latitude: 51.51919253774111, longitude: -0.13056578773788566),
                    type: Collectable.lamp
                ),
                Route.RouteCollectable(
                    location: CLLocationCoordinate2D(latitude: 51.516036179656275, longitude: -0.12470830890801224),
                    type: Collectable.lions
                ),
                Route.RouteCollectable(
                    location: CLLocationCoordinate2D(latitude: 37.3346203, longitude: -122.0084025),
                    type: Collectable.newspaper
                )
            ],
            stops: RouteStops
            , pathes: [nil, nil, nil]
        ),
        Route(
            dateCreated: Calendar.current.date(from: DateComponents(year: 2024, month: 1, day: 1, hour: 12, minute: 0))!,
            userCreated:"2",
            name: "Best London Route",
            description: "Visit all the main sights and see Big Ben following this fantastic route",
            saves: ["1", "2", "3", "4", "5", "1", "2", "3", "4"],
            collectables: [], //5,
            downloadDate: Date(),
            stops: RouteStops
            , pathes: [nil, nil, nil]
        ),
        Route(
            dateCreated: Calendar.current.date(from: DateComponents(year: 2024, month: 1, day: 1, hour: 12, minute: 0))!,
            userCreated: "1",
            name: "London Secrets",
            description: "Another description but shorter",
            saves: ["1", "2"],
            collectables: [], //5,
            stops: RouteStops
            , pathes: [nil, nil, nil]
        )
    ]
    
    public static var FriendsFeed: [FriendUpdate] = [
        FriendUpdate(
            friend: Users[0],
            description: "Anna completed a route",
            date: Date(),
            update: FriendUpdate.UpdateType.finishedRoute
        ),
        FriendUpdate(
            friend: Users[1],
            description: "Mary achieved a medal",
            date: Date(),
            update: FriendUpdate.UpdateType.award
        ),
        FriendUpdate(
            friend: Users[0],
            description: "Anna found a collectable",
            date: Date(),
            update: FriendUpdate.UpdateType.collectable
        ),
        
        FriendUpdate(
            friend: Users[1],
            description: "Mary added new friend",
            date: Date(),
            update: FriendUpdate.UpdateType.friend
        )
    ]
    
    public static var Users: [User] = [
        User(
            userId: "1",
            email: "anna@traveler.com",
            name: "Anna",
            userName: "annabanana",
            userDescription: "Traveler girl",
            awards: [
                User.UserAward(type: AwardTypes.attractionsVisited, level: 3, date: Date()),
                User.UserAward(type: AwardTypes.attractionsVisited, level: 2, date: Date()),
                User.UserAward(type: AwardTypes.attractionsVisited, level: 1, date: Date()),
                User.UserAward(type: AwardTypes.collectables, level: 1, date: Date()),
                User.UserAward(type: AwardTypes.friends, level: 1, date: Date()),
                User.UserAward(type: AwardTypes.kilometers, level: 1, date: Date()),
                User.UserAward(type: AwardTypes.minutes, level: 3, date: Date()),
                User.UserAward(type: AwardTypes.minutes, level: 2, date: Date()),
                User.UserAward(type: AwardTypes.minutes, level: 1, date: Date()),
                User.UserAward(type: AwardTypes.routesFinished, level: 1, date: Date()),
                User.UserAward(type: AwardTypes.routesFinished, level: 2, date: Date())
            ],
            collectables: [
                User.UserCollectable(
                    id: "11",
                    type: Collectable.bigBen,
                    finishedRouteId: "111"
                ),
                User.UserCollectable(
                    id: "12",
                    type: Collectable.bulldog,
                    finishedRouteId: "111"
                ),
                User.UserCollectable(
                    id: "13",
                    type: Collectable.bus,
                    finishedRouteId: "111"
                ),
                User.UserCollectable(
                    id: "14",
                    type: Collectable.fishAndChips,
                    finishedRouteId: "111"
                ),
                User.UserCollectable(
                    id: "15",
                    type: Collectable.newspaper,
                    finishedRouteId: "111"
                ),
                User.UserCollectable(
                    id: "15",
                    type: Collectable.lamp,
                    finishedRouteId: "111"
                ),
                User.UserCollectable(
                    id: "15",
                    type: Collectable.lions,
                    finishedRouteId: "111"
                )
            ],
            finishedRoutes: [
                User.FinishedRoute(
                    id: "111",
                    routeId: "1",
                    route: MockData.Routes[0],
                    spentMinutes: 5,
                    finishedDate: Date(),
                    collectables: 5
                ),
                User.FinishedRoute(
                    id: "111",
                    routeId: "1",
                    route: MockData.Routes[0],
                    spentMinutes: 5,
                    finishedDate: Date(),
                    collectables: 5
                ),
                User.FinishedRoute(
                    id: "111",
                    routeId: "1",
                    route: MockData.Routes[0],
                    spentMinutes: 5,
                    finishedDate: Date(),
                    collectables: 5
                ),
                User.FinishedRoute(
                    id: "111",
                    routeId: "1",
                    route: MockData.Routes[0],
                    spentMinutes: 5,
                    finishedDate: Date(),
                    collectables: 5
                ),
                User.FinishedRoute(
                    id: "111",
                    routeId: "1",
                    route: MockData.Routes[0],
                    spentMinutes: 5,
                    finishedDate: Date(),
                    collectables: 5
                ),
                User.FinishedRoute(
                    id: "111",
                    routeId: "1",
                    route: MockData.Routes[0],
                    spentMinutes: 5,
                    finishedDate: Date(),
                    collectables: 5
                ),
                User.FinishedRoute(
                    id: "111",
                    routeId: "1",
                    route: MockData.Routes[0],
                    spentMinutes: 5,
                    finishedDate: Date(),
                    collectables: 5
                ),
                User.FinishedRoute(
                    id: "111",
                    routeId: "1",
                    route: MockData.Routes[0],
                    spentMinutes: 5,
                    finishedDate: Date(),
                    collectables: 5
                ),
                User.FinishedRoute(
                    id: "111",
                    routeId: "1",
                    route: MockData.Routes[0],
                    spentMinutes: 5,
                    finishedDate: Date(),
                    collectables: 5
                ),
                User.FinishedRoute(
                    id: "111",
                    routeId: "1",
                    route: MockData.Routes[0],
                    spentMinutes: 5,
                    finishedDate: Date(),
                    collectables: 5
                ),
                User.FinishedRoute(
                    id: "111",
                    routeId: "1",
                    route: MockData.Routes[0],
                    spentMinutes: 5,
                    finishedDate: Date(),
                    collectables: 5
                )
            ]
        ),
        User(
            userId: "2",
            email: "mary@traveler.com",
            name: "Mary",
            userName: "mary_mary"
        )
    ]
    
    public static var RouteProgress: [RouteProgress] = [
        LondonExplorer.RouteProgress(route: Routes[2], collectables: [], stops: 2, user: Users[0], startTime: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 22, hour: 10, minute: 0)) ?? Date()),
        LondonExplorer.RouteProgress(route: Routes[2], collectables: [], stops: 3, user: Users[0]),
        LondonExplorer.RouteProgress(route: Routes[1], collectables: [], stops: 1, user: Users[1])
    ]
    
    public static var Attractions: [Attraction] = [
        Attraction(
            id: "3",
            name: "Big Ben & Houses of Parliament",
            shortDescription: "Iconic Clock Tower & Political Heart",
            fullDescription: "Hear the world-famous chime and delve into British democracy. Witness the grand clock tower of Big Ben, a neo-gothic masterpiece that has become synonymous with London. Hear the bongs of the Great Bell echo across the city, a sound that has marked the hour for over 150 years. Step inside the Houses of Parliament, the seat of the British government, and witness the chambers where crucial decisions are made. Take a guided tour to peek into the hallowed halls where Prime Ministers debate and pass laws. Explore the rich history of British democracy, from the signing of the Magna Carta to the evolution of modern politics. Big Ben and the Houses of Parliament stand as a testament to the enduring spirit of British democracy.",
            address: "London SW1A 0AA",
            coordinates: CLLocationCoordinate2D(latitude: 51.4991509, longitude: -0.1252128),
            imageURLs: [
                "https://www.historyhit.com/app/uploads/bis-images/5154061/BigBen-788x537.jpg?x46878",
                "https://media.gettyimages.com/id/648477278/photo/big-ben-in-london.jpg?b=1&s=1024x1024&w=gi&k=20&c=lW3CUAB1tUTV6iN2GxRNATeAagh2t3VC3q-2xyRndEE=",
                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQdQv8bu9oV9U0xSFyPbzpK6rQm94luj7m-Gw&s"
            ],
            categories: [
                .historical,
                .mustsee,
                .cultural,
                .unique
            ]
        ),
        Attraction(
            id: "1",
            name: "Buckingham Palace",
            shortDescription: "Witness Changing of the Guard",
            fullDescription: "Marvel at the iconic ceremony and royal residence. Witness the pomp and pageantry of the Changing of the Guard ceremony, a centuries-old tradition dating back to 1660. Watch the impeccably dressed soldiers in their colourful uniforms march to the rhythmic beat of military music. Explore the State Rooms, lavishly decorated with priceless art and opulent furniture. Walk the halls where kings and queens have resided for centuries and imagine the grand events unfolding within these walls. Buckingham Palace is a living symbol of the British monarchy, offering a glimpse into the grandeur and tradition of royal life.\n\nBuckingham Palace isn’t just a grand building. It’s a working royal residence! The Queen often holds important meetings and receptions here, and the Royal Standard is not flown during her absence. Be sure to check the official website before your visit to see if the flag is flying and if the State Rooms are open to the public.",
            address: "London SW1A 1AA", 
            coordinates: CLLocationCoordinate2D(latitude: 51.5013481, longitude: -0.1419304),
            imageURLs: [
                "https://cdn.londonandpartners.com/asset/buckingham-palace_image-courtesy-of-royal-collection-trust-his-majesty-king-charles-iii-2022-photo-andrew-holt_247a2afaed0312ad4e8fb6142fdcdd5a.jpg",
                "https://upload.wikimedia.org/wikipedia/commons/thumb/e/e9/Buckingham_Palace_UK.jpg/1200px-Buckingham_Palace_UK.jpg",
                "https://cdn.britannica.com/38/242638-050-D96EB78F/Buckingham-Palace-Victoria-Memorial-Tulips-London-England.jpg"
            ],
            categories: [
                .historical,
                .mustsee
            ]
        ),
        Attraction(
            id: "6",
            name: "British Museum",
            shortDescription: "Treasures from Around the Globe",
            fullDescription: "Journey through history with mummies, the Rosetta Stone, and more. Explore a vast collection of antiquities from around the world, spanning continents and civilizations. Decipher the mysteries of the Rosetta Stone, marvel at the awe-inspiring Egyptian mummies, and come face-to-face with the Parthenon sculptures.\n\nThe British Museum is a treasure trove of world history, housing over 8 million objects from every corner of the globe. Get lost amongst ancient Egyptian artifacts, explore the grandeur of the Roman Empire, and marvel at the intricate artistry of Asian cultures. The Rosetta Stone, a key to unlocking hieroglyphics, is a must-see, as are the awe-inspiring mummies from ancient Egypt. A visit to the British Museum is a journey through time, offering a glimpse into the rich tapestry of human history.",
            address: "Great Russell St, London WC1B 3DG",
            coordinates: CLLocationCoordinate2D(latitude: 51.5194155, longitude: -0.1269882),
            imageURLs: [
                "https://cdn.londonandpartners.com/asset/afternoon-tea-at-the-british-museum_dine-in-the-great-court-restaurant-at-the-british-museum-visitlondoncom-jon-reid_e71f2e08ac1964bc74090dae89f4de64.jpg",
                "https://upload.wikimedia.org/wikipedia/commons/3/3a/British_Museum_from_NE_2.JPG"
            ],
            categories: [
                .museums,
                .mustsee,
                .cultural
            ]
        ),
        Attraction(
            id: "2",
            name: "Tower of London",
            shortDescription: "Explore a Dark and Storied Past",
            fullDescription: "Uncover a thousand years of history within these imposing walls. Journey through time, from a medieval fortress built by William the Conqueror in 1070 to a royal palace that housed legendary figures like Henry VIII and Anne Boleyn.\n\nDescend into the depths of the infamous prison, where countless historical figures, including Sir Thomas More and Lady Jane Grey, met their demise. Explore the Crown Jewels, a dazzling collection of priceless gems and artefacts used for coronations for centuries. Marvel at the beauty of the Imperial State Crown, adorned with over 2,800 diamonds, and imagine the power and prestige it represents.\n\nThe Tower of London is a captivating blend of architectural marvels, historical significance, and chilling tales, offering a unique glimpse into London’s turbulent past.",
            address: "London EC3N 4AB",
            coordinates: CLLocationCoordinate2D(latitude: 51.5081266, longitude: -0.0760809),
            imageURLs: [
               "https://media.cntraveler.com/photos/6123bdb14fbeb917c1ae8c6f/16:9/w_2560,c_limit/Tower%20of%20London_GettyImages-155432006.jpg"
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
