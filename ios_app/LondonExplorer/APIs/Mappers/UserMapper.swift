//
//  UserMapper.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 26.08.2024.
//

import Foundation
import SwiftUI

class UserMapper {
    func mapToUser(from dto: UserWrapper) async -> User {
        let userAwards = mapAwards(for: dto.awards)
        let userCollectables = mapCollectables(from: dto.collectables)
        let finishedRoutes = mapFinishedRoutes(from: dto.finishedRoutes)
        
        let image: String? = dto.imageName != nil ? await getFullImage(for: dto.imageName!) : nil
        
        return User(
            userId: dto.userId,
            email: dto.email,
            name: dto.name,
            userName: dto.userName.lowercased(),
            userDescription: dto.description,
            imageName: image,
            awards: userAwards,
            collectables: userCollectables,
            friends: dto.friends ?? [],
            finishedRoutes: finishedRoutes.sorted { $0.finishedDate > $1.finishedDate }
        )
    }
    
    func getFullImage(for userImageName: String) async -> String? {
        let image = await ImagesRepository.shared.getUserImageUrl(userImageName: userImageName)
        return image
    }
    
    func mapAwards(for dto: [UserWrapper.UserAward]?) -> [User.UserAward] {
        var userAwards: [User.UserAward] = []
        if let awards = dto {
            for award in awards {
                do {
                    let userAward = try User.UserAward(from: award)
                    userAwards.append(userAward)
                } catch {
                    print("Failed to convert award: \(error.localizedDescription)")
                }
            }
        }
        
        return userAwards
    }
    
    func mapCollectables(from dto: [UserWrapper.UserCollectable]?) -> [User.UserCollectable] {
        var userCollectables: [User.UserCollectable] = []
        if let collectables = dto {
            for collectable in collectables {
                do {
                    let userCollectable = try User.UserCollectable(from: collectable)
                    userCollectables.append(userCollectable)
                } catch {
                    print("Failed to convert collectable: \(error.localizedDescription)")
                }
            }
        }
        
        return userCollectables
    }
    
    func mapFinishedRoutes(from dto: [UserWrapper.FinishedRoute]?) -> [User.FinishedRoute] {
        var finishedRoutes: [User.FinishedRoute] = []
        if let routes = dto {
            for route in routes {
                do {
                    let finishedRoute = try User.FinishedRoute(from: route)
                    finishedRoutes.append(finishedRoute)
                } catch {
                    print("Failed to convert finished date: \(error.localizedDescription)")
                }
            }
        }
        return finishedRoutes
    }
}
