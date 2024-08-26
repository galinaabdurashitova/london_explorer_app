//
//  ImagesRepository.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 23.06.2024.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseStorage

class ImagesRepository {
    static var shared = ImagesRepository()
    private let storageRef = Storage.storage().reference()
    
    private var attractionImagesCache: [String: [UIImage]] = [:]
    
//    private let storage = Storage.storage()
    private var usersImagesCache: [String: UIImage] = [:]
    
    enum ImageRepositoryError: Error {
        case listingFailed(String)
        case downloadFailed(String, String)
    }
    
    private init() {}
    
    func getAttractionImages(attractionId: String, maxNumber: Int = 5, reload: Bool = false) async throws -> [UIImage] {
        if !reload, let cachedAttraction = attractionImagesCache[attractionId] {
            return cachedAttraction
        }
        
        let imageRef = storageRef.child("attractions/" + attractionId)
        
        var images: [UIImage] = []
        
        do {
            let result = try await imageRef.listAll()
            
            
            for index in 0..<min(maxNumber, result.items.count) {
                do {
                    print(result.items[index].name)
                    let data = try await getData(from: result.items[index])
                    if let image = UIImage(data: data) {
                        images.append(image)
                    }
                } catch {
                    print("Failed to download image \(result.items[index].name): \(error.localizedDescription)")
                }
            }
        } catch {
            throw ImageRepositoryError.listingFailed(error.localizedDescription)
        }
            
        if images.isEmpty {
            throw ImageRepositoryError.downloadFailed(attractionId, "No images were successfully downloaded.")
        }
        
        attractionImagesCache[attractionId] = images
        
        return images
            
    }
    
    
    func getUserImage(userImageName: String) async throws -> UIImage {
        if let cachedUser = usersImagesCache[userImageName] {
            return cachedUser
        }
        
        let imageRef = storageRef.child("users/" + userImageName)
        
        do {
            let data = try await getData(from: imageRef)
            print("Data gotten")
            if let image = UIImage(data: data) {
                usersImagesCache[userImageName] = image
                return image
            } else {
                throw ImageRepositoryError.downloadFailed(userImageName, "No images were successfully downloaded.")
            }
        } catch {
            throw ImageRepositoryError.downloadFailed(userImageName, "No images were successfully downloaded.")
        }
    }
    
    private func getData(from reference: StorageReference) async throws -> Data {
        return try await withCheckedThrowingContinuation { continuation in
            reference.getData(maxSize: 5 * 1024 * 1024) { data, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let data = data {
                    continuation.resume(returning: data)
                }
            }
        }
    }
}
