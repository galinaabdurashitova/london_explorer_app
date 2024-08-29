//
//  ServiceClass.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 20.08.2024.
//

import Foundation

class Service {
    enum RequestMethods: String {
        case get = "GET"
        case post = "POST"
        case patch = "PATCH"
        case delete = "DELETE"
    }
    
    func checkResponse(response: URLResponse, service: String, method: String) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw ServiceError.invalidResponse
        }
        
        print("\(service) \(method): \(httpResponse.statusCode)")
        switch httpResponse.statusCode {
        case 200..<300:
            break
        case 400:
            throw ServiceError.serverError(400)
        case 404:
            throw ServiceError.serverError(404)
        case 500:
            throw ServiceError.serverError(500)
        default:
            throw ServiceError.serverError(httpResponse.statusCode)
        }
    }
    
    func makeRequest(method: RequestMethods, url: URL, body: Encodable? = nil, serviceName: String, methodName: String) async throws -> Data {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if let requestBody = body {
            request.httpBody = try JSONEncoder().encode(requestBody)
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        try self.checkResponse(response: response, service: serviceName, method: methodName)
        return data
    }
    
    func decodeResponse<T: Decodable>(from data: Data, as type: T.Type, serviceName: String, methodName: String) throws -> T {
        do {
            let decodedResponse = try JSONDecoder().decode(T.self, from: data)
            return decodedResponse
        } catch let error {
            if let decodingError = error as? DecodingError {
                print("Failed to decode response: \(String(data: data, encoding: .utf8) ?? "N/A")")
                switch decodingError {
                case .typeMismatch(let type, let context):
                    print("\(serviceName) \(methodName): decoding error - Type mismatch for type \(type) in context \(context.debugDescription)")
                case .valueNotFound(let value, let context):
                    print("\(serviceName) \(methodName): decoding error - Value not found for value \(value) in context \(context.debugDescription)")
                case .keyNotFound(let key, let context):
                    print("\(serviceName) \(methodName): decoding error - Key '\(key)' not found: \(context.debugDescription)")
                case .dataCorrupted(let context):
                    print("\(serviceName) \(methodName): decoding error - Data corrupted: \(context.debugDescription)")
                @unknown default:
                    print("\(serviceName) \(methodName): decoding error - Unknown decoding error")
                }
                throw NSError(domain: serviceName, code: 1, userInfo: [NSLocalizedDescriptionKey: "Decoding error: \(decodingError.localizedDescription)"])
            } else {
                print(error.localizedDescription)
                throw error
            }
        }
    }
}
