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
                    HStack {
                        Text("Your friends don’t have recent updates")
                            .font(.system(size: 16))
                            .opacity(0.5)
                        
                        Spacer()
                        
                        Button(action: {
                            // Go to user search
                        }) {
                            HStack (spacing: 7) {
                                Text("Add a friend")
                                    .font(.system(size: 14, weight: .semibold))
                                Image(systemName: "chevron.forward")
                                    .icon(size: 10)
                            }
                            .foregroundColor(Color.black)
                        }
                    }
                    .padding(.horizontal, 15.0)
                    .padding(.vertical, 20.0)
                    .background(Color.lightBlue)
                    .cornerRadius(8)
                }
            }
        }
    }
}

#Preview {
    ScrollView {
        FriendsFeed(
            friendsFeed: Binding<[FriendUpdate]> (
                get: { return MockData.FriendsFeed },
                set: { _ in }
            )
        )
    }
    .padding()
}
