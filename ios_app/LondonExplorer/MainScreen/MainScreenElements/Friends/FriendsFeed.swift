//
//  FriendsFeed.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 30.05.2024.
//

import Foundation
import SwiftUI

struct FriendsFeed: View {
    @Binding var friendsFeed: [FriendUpdate]
    
    var body: some View {
        VStack (spacing: 20) {
            HStack {
                SectionHeader(
                    headline: .constant("Friends Feed"),
                    subheadline: .constant("Your friends’ latest updates")
                )
                Spacer()
            }
            
            VStack (spacing: 12) {
                if friendsFeed.count > 0 {
                    ForEach ($friendsFeed) { update in
                        FeedUpdate(update: update)
                    }
                } else {                        
                    Button(action: {
                        // Go to user search
                    }) {
                        ActionBanner(text: "Your friends don’t have recent updates", actionText: "Add a friend")
                    }
                }
            }
        }
    }
}

#Preview {
    ScrollView {
        FriendsFeed(friendsFeed: .constant(MockData.FriendsFeed))
    }
    .padding()
}
