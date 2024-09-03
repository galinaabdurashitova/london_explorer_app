//
//  FeedUpdate.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 31.05.2024.
//

import Foundation
import SwiftUI

struct FeedUpdate: View {
    @Binding var update: FriendUpdate
    
    var body: some View {
        NavigationLink(value: ProfileNavigation.profile(update.friend)) {
            HStack {
                LoadingUserImage(userImage: $update.friend.imageName, imageSize: 50)
                
                VStack (alignment: .leading, spacing: 2) {
                    Text(update.formattedDate)
                        .font(.system(size: 12, weight: .semibold))
                        .opacity(0.5)
                    Text(self.getUpdateText())
                        .headline()
                    
                    if update.update == .finishedRoute, let routeName = update.routeName {
                        Text(routeName)
                            .subheadline()
                    } else if update.update != .finishedRoute {
                        Text(update.description)
                            .subheadline()
                    }
                }
                Spacer()
                
                update.getIcon()
                    .icon(size: 50)
            }
            .padding(.all, 15.0)
            .foregroundColor(Color.black)
            .background(Color.lightBlue)
            .cornerRadius(8)
        }
    }
    
    private func getUpdateText() -> String {
        update.update == .award ? "\(update.friend.name) recieved an award"
             : update.update == .collectable ? "\(update.friend.name) found a collectable"
             : update.update == .friend ? "\(update.friend.name) added a new friend"
             : update.update == .finishedRoute ? "\(update.friend.name) finished a route"
             : "An update from \(update.friend.name)"
    }
}

#Preview {
    FeedUpdate(update: Binding<FriendUpdate> (
        get: { return MockData.FriendsFeed[0] },
        set: { _ in }
    ))
    .padding()
}
