//
//  RouteMapper.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 25.08.2024.
//

import Foundation
import SwiftUI

class RouteMapper {
    func mapToRoute(from dto: RouteWrapper) async throws -> Route {
        let dateCreated = try checkDate(dto.dateCreated, dateType: "date created")
        let datePublished = try checkDate(dto.datePublished, dateType: "date published")
        
        let image = try await loadImage(for: dto.stops[0].attractionId)
        let collectables = try mapCollectables(from: dto.collectables)
        let stops = try await mapStops(from: dto.stops)
        let pathes = await calculatePathes(for: stops)
        
        return Route(
            id: dto.routeId,
            dateCreated: dateCreated,
            userCreated: dto.userCreated,
            name: dto.routeName,
            description: dto.routeDescription,
            image: image,
            saves: dto.saves ?? [],
            collectables: collectables,
            datePublished: datePublished,
            stops: stops,
            pathes: pathes,
            calculatedRotueTime: Double(dto.routeTime)
        )
    }
    
    private func checkDate(_ dateString: String, dateType: String) throws -> Date {
        guard let date = DateConverter(format: "yyyy-MM-dd'T'HH:mm:ss.SSSZ").toDate(from: dateString) else {
            let debugDescription = "Cannot convert \(dateType)"
            print("Route mapper: decoding error - Data corrupted: \(debugDescription)")
            throw DecodingError.dataCorrupted(
                DecodingError.Context(
                    codingPath: [],
                    debugDescription: debugDescription
                )
            )
        }
        
        return date
    }
    
    private func loadImage(for attractionId: String) async throws -> UIImage {
        let images = try await ImagesRepository.shared.getAttractionImages(attractionId: attractionId, maxNumber: 1)
        guard !images.isEmpty else {
            let debugDescription = "Cannot get image"
            print("decoding error - Value not found for value \(UIImage.self) in context \(debugDescription)")
            throw DecodingError.valueNotFound(
                UIImage.self,
                DecodingError.Context(
                    codingPath: [],
                    debugDescription: debugDescription
                )
            )
        }
        
        return images[0]
    }
    
    private func mapCollectables(from dto: [RouteWrapper.RouteCollectable]) throws -> [Route.RouteCollectable] {
        var routeCollectables: [Route.RouteCollectable] = []
        for collectable in dto {
            do {
                let routeCollectable = try Route.RouteCollectable(from: collectable)
                routeCollectables.append(routeCollectable)
            } catch {
                print("Error converting collectable: \(error.localizedDescription)")
            }
        }
        
        guard !routeCollectables.isEmpty else {
            let debugDescription = "No route collectables found"
            print("Route mapper: decoding error - Data corrupted: \(debugDescription)")
            throw DecodingError.dataCorrupted(
                    DecodingError.Context(
                        codingPath: [],
                        debugDescription: debugDescription
                    )
                )
        }
        
        return routeCollectables
    }
    
    private func mapStops(from dto: [RouteWrapper.RouteStop]) async throws -> [Route.RouteStop] {
        var routeStops: [Route.RouteStop] = []
        for stop in dto {
            do {
                var attraction = try await AttractionsService().fetchAttraction(attractionId: stop.attractionId)
                attraction.images = try await ImagesRepository.shared.getAttractionImages(attractionId: stop.attractionId, maxNumber: 1)
                let routeStop = Route.RouteStop(id: stop.attractionId, stepNo: stop.stepNumber, attraction: attraction)
                routeStops.append(routeStop)
            } catch {
                print("Error converting stop: \(error.localizedDescription)")
            }
        }
        
        guard !routeStops.isEmpty else {
            let debugDescription = "No route stops found"
            print("Route mapper: decoding error - Data corrupted: \(debugDescription)")
            throw DecodingError.dataCorrupted(
                    DecodingError.Context(
                        codingPath: [],
                        debugDescription: debugDescription
                    )
                )
        }
        
        return routeStops
    }
    
    private func calculatePathes(for stops: [Route.RouteStop]) async -> [CodableMKRoute?] {
        guard stops.count > 0 else { return [] }
        
        var pathes = Array<CodableMKRoute?>(repeating: nil, count: stops.count-1)
        for index in 1..<stops.count {
            if let calculatedRouteStep = await RouteMapHelper.calculateRouteStep(start: stops[index-1].attraction.coordinates, destination: stops[index].attraction.coordinates) {
                pathes[index-1] = CodableMKRoute(from: calculatedRouteStep)
            }
        }
        
        return pathes
    }
}
