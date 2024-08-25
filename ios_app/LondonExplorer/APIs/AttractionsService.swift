//
//  AttractionsService.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 23.06.2024.
//

import Foundation
import MapKit

protocol AttractionsServiceProtocol: Service {
    func fetchAllAttractions() async throws -> [Attraction]
    func fetchAttractions(attractionIds: [String]?) async throws -> [Attraction]
    func fetchAttraction(attractionId: String) async throws -> Attraction
}

class AttractionsService: Service, AttractionsServiceProtocol {
    // http://attractions-api-gmabdurashitova.replit.app/api/attractions
    private let serviceURL = URL(string: "http://localhost:8083/api/attractions")!
    private let serviceName = "Attractions service"
    
    
    func fetchAllAttractions() async throws -> [Attraction] {
        return try await fetchAttractions(attractionIds: nil)
    }
    
    
    func fetchAttractions(attractionIds: [String]? = nil) async throws -> [Attraction] {
        let methodName = "fetchAttractions"
        let queryItems = attractionIds?.joined(separator: ",") ?? ""
        let url = serviceURL.appending(queryItems: [URLQueryItem(name: "attractionIds", value: queryItems)])

        let data = try await self.makeRequest(method: .get, url: url, serviceName: serviceName, methodName: methodName)
        let attractions = try self.decodeResponse(from: data, as: [AttractionWrapper].self, serviceName: serviceName, methodName: methodName)
        
        var responseAttractions: [Attraction] = []
        for attraction in attractions[0..<20] {     // Remove [0..<20] part to get all atractions - reduced for speed
            if !attraction.categories.isEmpty {
                let newAttraction = Attraction(from: attraction)
                responseAttractions.append(newAttraction)
            }
        }
        
        guard !attractions.isEmpty else {
            throw NSError(domain: serviceName, code: 1, userInfo: [NSLocalizedDescriptionKey: "No attractions available."])
        }
        
        return responseAttractions
    }
    
    
    func fetchAttraction(attractionId: String) async throws -> Attraction {
        let methodName = "fetchAttraction"
        let url = serviceURL.appendingPathComponent("\(attractionId)")
        
        let data = try await self.makeRequest(method: .get, url: url, serviceName: serviceName, methodName: methodName)
        let attraction = try self.decodeResponse(from: data, as: AttractionWrapper.self, serviceName: serviceName, methodName: methodName)
        return Attraction(from: attraction)
    }
}
