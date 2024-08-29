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
    private var attractionImageURLsCache: [String: [String]] = [:]
    
    private var usersImagesCache: [String: UIImage] = [:]
    private var usersImageURLsCache: [String: String] = [:]
    
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
                    let data = try await getData(from: result.items[index])
                    if let image = UIImage(data: data) {
                        images.append(image)
                    }
                    attractionImagesCache[attractionId] = images
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
    
    func getAttractionImagesURL(attractionId: String) async throws -> [String] {
        if let cachedAttraction = attractionImageURLsCache[attractionId] {
            return cachedAttraction
        }
        
        let imageRef = storageRef.child("attractions/" + attractionId)
        
        var imagesURL: [String] = []
        
        do {
            let result = try await imageRef.listAll()
            
            for index in 0..<result.items.count {
                if let url = await getImageURL(from: result.items[index]) {
                    imagesURL.append(url.absoluteString)
                }
            }
            attractionImageURLsCache[attractionId] = imagesURL
        } catch {
            throw ImageRepositoryError.listingFailed(error.localizedDescription)
        }
            
        if imagesURL.isEmpty {
            throw ImageRepositoryError.downloadFailed(attractionId, "No image URL were successfully found.")
        }
        
        return imagesURL
    }
    
    func getUserImageUrl(userImageName: String) async -> String? {
        if let cachedUser = usersImageURLsCache[userImageName] {
            return cachedUser
        }
        
        let imageRef = storageRef.child("users/" + userImageName)
        
        if let url = await getImageURL(from: imageRef) {
            usersImageURLsCache[userImageName] = url.absoluteString
            return url.absoluteString
        } else {
            return nil
        }
    }
    
    private func getImageURL(from reference: StorageReference) async -> URL? {
        return await withCheckedContinuation { continuation in
            reference.downloadURL { url, error in
                if let error = error {
                    print("Error fetching image URL: \(error)")
                    continuation.resume(returning: nil)
                    return
                }
                continuation.resume(returning: url)
            }
        }
    }
    
    func uploadImage(userId: String, image: UIImage) async throws -> String? {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            throw NSError(domain: "ImageErrorDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to convert image to JPEG data"])
        }
        
        let imageRef = storageRef.child("users").child(UUID().uuidString + ".jpg")
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        do {
            _ = try await imageRef.putDataAsync(imageData, metadata: metadata)
            
            let downloadURL = try await imageRef.downloadURL()
            usersImagesCache[userId] = image
            usersImageURLsCache[userId] = downloadURL.absoluteString
            return downloadURL.lastPathComponent
        } catch {
            print("Error uploading image: \(error.localizedDescription)")
            throw error
        }
    }
}
