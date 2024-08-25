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
    
//    private var attractionImagesCache = [String: [UIImage]]()
    
//    private let storage = Storage.storage()
//    private var imageCache = [String: UIImage]()
    
    enum ImageRepositoryError: Error {
        case listingFailed(String)
        case downloadFailed(String, String)
    }
    
    private init() {}
    
    func getAttractionImage(attractionId: String) async throws -> [UIImage] {
//        if let cachedAttraction = attractionImagesCache[attraction] {
//            return cachedAttraction
//        }
        
        let imageRef = storageRef.child("attractions/" + attractionId)
        
        var images = [UIImage]()
        
        do {
            let result = try await imageRef.listAll()
            
            if result.items.count > 0 {
                let item = result.items[0]
                do {
                    let data = try await getData(from: item)
                    if let image = UIImage(data: data) {
                        images.append(image)
                        
                        // It causes crashes - need a fix
//                        if var cachedAttraction = attractionImagesCache[attraction] {
//                            cachedAttraction.append(image)
//                            attractionImagesCache[attraction] = cachedAttraction
//                        } else {
//                            attractionImagesCache[attraction] = [image]
//                        }
                    }
                } catch {
                    print("Failed to download image \(item.name): \(error.localizedDescription)")
                }
            }
        } catch {
            throw ImageRepositoryError.listingFailed(error.localizedDescription)
        }
            
        if images.isEmpty {
            throw ImageRepositoryError.downloadFailed(attractionId, "No images were successfully downloaded.")
        }
        
        return images
            
    }
    
    func getAttractionImages(attractionId: String) async throws -> [UIImage] {
//        if let cachedAttraction = attractionImagesCache[attraction] {
//            return cachedAttraction
//        }
        
        let imageRef = storageRef.child("attractions/" + attractionId)
        
        var images = [UIImage]()
        
        do {
            let result = try await imageRef.listAll()
            
            for item in result.items {
                do {
                    let data = try await getData(from: item)
                    if let image = UIImage(data: data) {
                        images.append(image)
                        
                        // It causes crashes - need a fix
//                        if var cachedAttraction = attractionImagesCache[attraction] {
//                            cachedAttraction.append(image)
//                            attractionImagesCache[attraction] = cachedAttraction
//                        } else {
//                            attractionImagesCache[attraction] = [image]
//                        }
                    }
                } catch {
                    print("Failed to download image \(item.name): \(error.localizedDescription)")
                }
            }
        } catch {
            throw ImageRepositoryError.listingFailed(error.localizedDescription)
        }
            
        if images.isEmpty {
            throw ImageRepositoryError.downloadFailed(attractionId, "No images were successfully downloaded.")
        }
        
        return images
    }
    
//    func getUserImage(userId: String) async throws -> UIImage? {
//        let imageRef = storageRef.child("users/" + userId)
//        
//        do {
//            let result = try await imageRef.listAll()
//            
//            if result.items.count > 0 {
//                let item = result.items[0]
//                do {
//                    let data = try await getData(from: item)
//                    if let image = UIImage(data: data) {
//                        images.append(image)
//                        
//                        // It causes crashes - need a fix
////                        if var cachedAttraction = attractionImagesCache[attraction] {
////                            cachedAttraction.append(image)
////                            attractionImagesCache[attraction] = cachedAttraction
////                        } else {
////                            attractionImagesCache[attraction] = [image]
////                        }
//                    }
//                } catch {
//                    print("Failed to download image \(item.name): \(error.localizedDescription)")
//                }
//            }
//        } catch {
//            throw ImageRepositoryError.listingFailed(error.localizedDescription)
//        }
//            
//        if images.isEmpty {
//            throw ImageRepositoryError.downloadFailed(attractionId, "No images were successfully downloaded.")
//        }
//        
//        return images
//            
//    }
    
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
