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
        
        let image: UIImage? = dto.imageName != nil ? await loadImage(for: dto.imageName!) : nil
        
        return User(
            userId: dto.userId,
            email: dto.email,
            name: dto.name,
            userName: dto.userName.lowercased(),
            userDescription: dto.description,
            imageName: dto.imageName,
            image: image,
            awards: userAwards,
            collectables: userCollectables,
            friends: dto.friends ?? [],
            finishedRoutes: finishedRoutes.sorted { $0.finishedDate > $1.finishedDate }
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
