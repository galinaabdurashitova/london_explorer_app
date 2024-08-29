//
//  SettingsTypes.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 27.08.2024.
//

import Foundation
import SwiftUI

enum SettingsType: Equatable, Hashable, CaseIterable {
    case picture
    case name
    case username
    case description
    
    var limit: Int {
        switch self {
        case .picture:
            return 0
        case .name:
            return 64
        case .username:
            return 16
        case .description:
            return 2048
        }
    }
    
    var description: String {
        switch self {
        case .picture:
            return "Change profile picture"
        case .name:
            return "Change name"
        case .username:
            return "Change username"
        case .description:
            return "Change profile description"
        }
    }
    
    @ViewBuilder
    func field(for user: User) -> some View {
        switch self {
        case .picture:
            if let image = user.image {
                Image(uiImage: image)
                    .profilePicture(size: 50)
            } else {
                Image("User3DIcon")
                    .profilePicture(size: 50)
            }
        case .name:
            Text(user.name)
                .font(.system(size: 18, weight: .light))
        case .username:
            Text(user.userName)
                .font(.system(size: 18, weight: .light))
        case .description:
            if let description = user.description {
                Text(description)
                    .font(.system(size: 18, weight: .light))
            }
        }
    }
    
    @ViewBuilder
    func link(for user: User) -> some View {
        NavigationLink(value: self) {
            HStack {
                if self == .picture {
                    self.field(for: user)
                }
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(self.description)
                        .font(.system(size: 15, weight: .semibold))
                    
                    if self != .picture {
                        self.field(for: user)
                    }
                }
                
                Spacer()
                Image(systemName: "chevron.right")
            }
        }
        .foregroundColor(Color.black)
    }
}
