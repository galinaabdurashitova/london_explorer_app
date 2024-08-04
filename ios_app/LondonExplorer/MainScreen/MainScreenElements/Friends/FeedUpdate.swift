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
        HStack {
            Image(uiImage: update.friend.image)
                .profilePicture(size: 50)
            VStack (alignment: .leading, spacing: 2) {
                Text(update.formattedDate)
                    .font(.system(size: 10, weight: .semibold))
                    .opacity(0.5)
                Text(update.caption)
                    .headline()
                Text(update.subCaption)
                    .subheadline()
            }
            Spacer()
            
            update.getIcon()
                .icon(size: 50)
        }
        .padding(.all, 15.0)
        .background(Color.lightBlue)
        .cornerRadius(8)
    }
}

#Preview {
    FeedUpdate(update: Binding<FriendUpdate> (
        get: { return MockData.FriendsFeed[0] },
        set: { _ in }
    ))
    .padding()
}
