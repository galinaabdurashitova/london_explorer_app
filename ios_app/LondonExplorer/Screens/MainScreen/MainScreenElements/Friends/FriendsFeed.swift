//
//  FriendsFeed.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 30.05.2024.
//

import Foundation
import SwiftUI

struct FriendsFeed: View {
    @EnvironmentObject var auth: AuthController
    @ObservedObject var viewModel: FriendsFeedViewModel
    
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
                if viewModel.friendsRequests.count > 0 {
                    ForEach ($viewModel.friendsRequests) { request in
                        FriendRequestBanner(viewModel: viewModel, user: request)
                    }
                }
                
                if viewModel.updates.count > 0 {
                    ForEach ($viewModel.updates) { update in
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
        .onAppear {
            viewModel.reloadFeed(userId: auth.profile.id)
        }
    }
}

#Preview {
    ScrollView {
        FriendsFeed(viewModel: FriendsFeedViewModel())
            .environmentObject(AuthController())
    }
    .padding()
}
