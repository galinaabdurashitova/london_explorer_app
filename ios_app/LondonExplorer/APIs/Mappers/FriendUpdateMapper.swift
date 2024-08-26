//
//  FriendUpdateMapper.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 26.08.2024.
//

import Foundation
import SwiftUI

class FriendUpdateMapper {
    func mapToFriendUpdate(from dto: FriendUpdateWrapper) async throws -> FriendUpdate {
        let updateType = try mapUpdateType(from:  dto.updateType)
        let date = try mapUpdateDate(from: dto.updateDate)
        let friend = await mapUpdateUser(from: dto)
        
        return FriendUpdate(
            friend: friend,
            description: dto.description,
            date: date,
            update: updateType
        )
    }
    
    func mapUpdateType(from dto: String) throws -> FriendUpdate.UpdateType {
        guard let updateType = FriendUpdate.UpdateType(rawValue: dto) else {
            throw DecodingError.dataCorrupted(
                    DecodingError.Context(
                        codingPath: [],
                        debugDescription: "Cannot convert update type"
                    )
                )
        }
        return updateType
    }
    
    func mapUpdateDate(from dto: String) throws -> Date {
        guard let date = DateConverter(format: "yyyy-MM-dd'T'HH:mm:ss.SSSZ").toDate(from: dto) else {
            throw DecodingError.dataCorrupted(
                    DecodingError.Context(
                        codingPath: [],
                        debugDescription: "Cannot convert date"
                    )
                )
        }
        return date
    }
    
    func mapUpdateUser(from dto: FriendUpdateWrapper) async -> User {
        let image: UIImage? = dto.imageName != nil ? await loadImage(for: dto.imageName!) : nil
        
        return User(
            userId: dto.userId,
            name: dto.name,
            userName: dto.userName,
            imageName: dto.imageName,
            image: image
        )
    }
    
    func loadImage(for userImageName: String) async -> UIImage? {
        do {
            let image = try await ImagesRepository.shared.getUserImage(userImageName: userImageName)
            return image
        } catch {
            print("Could not get user's image")
            return nil
        }
    }
}
