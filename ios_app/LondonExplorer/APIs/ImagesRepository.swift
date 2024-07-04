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

class ImagesRepository: ObservableObject {
//    private let storage = Storage.storage()
    private let storageRef = Storage.storage().reference()
//    private var attractionImagesCache = [Attraction: [UIImage]]()
//    private var imageCache = [String: UIImage]()
    
    enum ImageRepositoryError: Error {
        case listingFailed(String)
        case downloadFailed(String, String)
    }
    
    func getAttractionImages(attraction: Attraction) async throws -> [UIImage] {
//        if let cachedAttraction = attractionImagesCache[attraction] {
//            return cachedAttraction
//        }
        
        let imageRef = storageRef.child("attractions/" + attraction.id)
        
        do {
            let result = try await imageRef.listAll()
            var images = [UIImage]()
            
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
            
            if images.isEmpty {
                throw ImageRepositoryError.downloadFailed(attraction.id, "No images were successfully downloaded.")
            }
            
            return images
        } catch {
            throw ImageRepositoryError.listingFailed(error.localizedDescription)
        }
    }
    
    private func getData(from reference: StorageReference) async throws -> Data {
        return try await withCheckedThrowingContinuation { continuation in
            reference.getData(maxSize: 10 * 1024 * 1024) { data, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let data = data {
                    continuation.resume(returning: data)
                }
            }
        }
    }
}
