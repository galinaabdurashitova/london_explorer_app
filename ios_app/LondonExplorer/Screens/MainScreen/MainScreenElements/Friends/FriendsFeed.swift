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
    @EnvironmentObject var globalSettings: GlobalSettings
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
                if viewModel.isLoading {
                    loader
                } else if viewModel.error {
                    WidgetError(text: "friends feed") {
                        viewModel.reloadFeed(userId: auth.profile.id)
                    }
                } else if viewModel.friendsRequests.count > 0 || viewModel.updates.count > 0 {
                    ForEach ($viewModel.friendsRequests) { request in
                        FriendRequestBanner(viewModel: viewModel, user: request)
                    }
                    
                    ForEach ($viewModel.updates) { update in
                        FeedUpdate(update: update)
                    }
                } else {                        
                    Button(action: self.goToUserSearch) {
                        ActionBanner(text: "Your friends don’t have recent updates", actionText: "Add a friend")
                    }
                }
            }
        }
        .onAppear {
            viewModel.reloadFeed(userId: auth.profile.id)
        }
    }
    
    private var loader: some View {
        VStack {
            ForEach(0..<4) { _ in
                Color(Color.black.opacity(0.05))
                    .frame(height: 80)
                    .loading(isLoading: true)
            }
        }
    }
    
    private func goToUserSearch() {
        globalSettings.goToTab(.search)
        globalSettings.goToSearchTab(.users)
    }
}

#Preview {
    ScrollView {
        FriendsFeed(viewModel: FriendsFeedViewModel())
            .environmentObject(AuthController())
            .environmentObject(GlobalSettings())
    }
    .padding()
}
