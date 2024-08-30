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
    
    private var attractionMapper: AttractionMapper = AttractionMapper()
    
    
    func fetchAllAttractions() async throws -> [Attraction] {
        return try await fetchAttractions(attractionIds: nil)
    }
    
    
    func fetchAttractions(attractionIds: [String]? = nil) async throws -> [Attraction] {
        let methodName = "fetchAttractions"
        let queryItems = attractionIds?.joined(separator: ",") ?? ""
        let url = serviceURL.appending(queryItems: [URLQueryItem(name: "attractionIds", value: queryItems)])

        if let cached: [Attraction] = CacheManager.shared.getCachedData(for: url.absoluteString) {
            return cached
        }
        
        let data = try await self.makeRequest(method: .get, url: url, serviceName: serviceName, methodName: methodName)
        let responseAttractions = try await decodeAttractions(from: data, methodName: methodName)
        
        CacheManager.shared.saveData(responseAttractions, for: url.absoluteString)
        
        return responseAttractions
    }
    
    
    func fetchAttraction(attractionId: String) async throws -> Attraction {
        let methodName = "fetchAttraction"
        let url = serviceURL.appendingPathComponent("\(attractionId)")
        
        if let cached: Attraction = CacheManager.shared.getCachedData(for: url.absoluteString) {
            return cached
        }
        
        let data = try await self.makeRequest(method: .get, url: url, serviceName: serviceName, methodName: methodName)
        let attraction = try self.decodeResponse(from: data, as: AttractionWrapper.self, serviceName: serviceName, methodName: methodName)
        let attractionResponse = try await attractionMapper.mapToAttraction(from: attraction)
        
        CacheManager.shared.saveData(attractionResponse, for: url.absoluteString)
        
        return attractionResponse
    }
    
    private func decodeAttractions(from data: Data, methodName: String) async throws -> [Attraction] {
        let attractions = try self.decodeResponse(from: data, as: [AttractionWrapper].self, serviceName: serviceName, methodName: methodName)
        
        var responseAttractions: [Attraction] = []
        for attraction in attractions {     // Remove [0..<20] part to get all atractions - reduced for speed
            if !attraction.categories.isEmpty {
                do {
                    let newAttraction = try await attractionMapper.mapToAttraction(from: attraction)
                    responseAttractions.append(newAttraction)
                } catch {
                    print("Could not map the attraction: \(attraction.name)")
                }
            }
        }
        
        return responseAttractions
    }
}
