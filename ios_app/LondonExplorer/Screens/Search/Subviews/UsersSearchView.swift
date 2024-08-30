//
//  UsersSearchView.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 28.08.2024.
//

import Foundation
import SwiftUI

struct UsersSearchView: View {
    @ObservedObject var viewModel: SearchViewModel
    
    var body: some View {
        VStack {
            SearchBar(searchText: $viewModel.searchedUser) {
                viewModel.filterUsers()
            }
            
            if viewModel.isFetchingUsers {
                loader
            } else if viewModel.errorUsers {
                ErrorScreen {
                    Task { await viewModel.fetchUsers() }
                }
            } else {
                ForEach(viewModel.searchedUser.isEmpty ? viewModel.users : viewModel.filteredUsers) { user in
                    NavigationLink(value: ProfileNavigation.profile(user)) {
                        userCard(user: user)
                    }
                }
            }
        }
    }
    
    private func userCard(user: User) -> some View {
        HStack {
            LoadingUserImage(userImage: Binding(get: { user.imageName }, set: { _ in }), imageSize: 50)
            
            VStack(alignment: .leading, spacing: 0) {
                Text(user.name)
                    .sectionCaption()
                Text("@\(user.userName)")
                    .sectionSubCaption()
            }
            .foregroundColor(Color.black)
            
            Spacer()
        }
        .padding(.vertical, 10)
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color.black.opacity(0.5)),
            alignment: .bottom
        )
    }
    
    private var loader: some View {
        VStack {
            ForEach(0..<5) { _ in
                HStack {
                    Color(Color.black.opacity(0.05))
                        .frame(width: 50, height: 50)
                        .loading(isLoading: true)
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Color(Color.black.opacity(0.05))
                            .frame(width: 150, height: 24)
                            .loading(isLoading: true)
                        
                        Color(Color.black.opacity(0.05))
                            .frame(width: 100, height: 16)
                            .loading(isLoading: true)
                    }
                    
                    Spacer()
                }
                .padding(.vertical, 10)
                .overlay(
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(Color.black.opacity(0.5)),
                    alignment: .bottom
                )
            }
        }
    }
}

#Preview {
    UsersSearchView(viewModel: SearchViewModel())
        .padding()
}
