//
//  FriendButton.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 21.08.2024.
//

import Foundation
import SwiftUI

struct FriendButton: View {
    enum Stage: String {
        case friends = "Friends"
        case requested = "Requested"
        case add = "Add friend"
        
        var iconName: String {
            switch self {
            case .friends:      return "person.2.fill"
            case .requested:    return "checkmark"
            case .add:          return "person.badge.plus"
            }
        }
        
        var color: Color {
            switch self {
            case .friends:      return Color.blueAccent
            case .requested:    return Color.greenAccent
            case .add:          return Color.black.opacity(0.2)
            }
        }
    }
    
    @State var type: Stage
    
    var body: some View {
        HStack {
            Text(type.rawValue)
                .foregroundColor(Color.white)
                .font(.system(size: 13))
            Image(systemName: type.iconName)
                .icon(size: 20, colour: Color.white)
        }
        .padding(.all, 5)
        .background(type.color)
        .cornerRadius(8)
    }
}

#Preview {
    FriendButton(type: .add)
}
