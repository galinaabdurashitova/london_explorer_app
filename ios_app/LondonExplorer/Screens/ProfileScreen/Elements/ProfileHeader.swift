//
//  ProfileHeader.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 25.08.2024.
//

import Foundation
import SwiftUI

struct ProfileHeader: View {
    @EnvironmentObject var auth: AuthController
    @ObservedObject var viewModel: ProfileViewModel
    
    var body: some View {
        if viewModel.userLoading {
            loader
        } else {
            HStack(spacing: 15) {
                LoadingUserImage(userImage: $viewModel.user.imageName, imageSize: 120)
                
                VStack(alignment: .leading, spacing: 20) {
                    HStack {
                        VStack(alignment: .leading, spacing: 0) {
                            Text(viewModel.user.name)
                                .screenHeadline()
                            Text("@\(viewModel.user.userName)")
                                .subheadline()
                        }
                        
                        Spacer()
                        
                        if viewModel.user.id == auth.profile.id {
                            NavigationLink(value: ProfileNavigation.settings) {
                                Image(systemName: "gearshape")
                                    .icon(size: 30, colour: Color.black.opacity(0.3))
                            }
                        } else {
                            FriendButton(viewModel: viewModel)
                        }
                    }
                    
                    buttons
                }
            }
        }
    }
    
    private var buttons: some View {
        HStack(spacing: 0) {
            HStack(spacing: 10) {
                Text(String(viewModel.routes.count))
                    .font(.system(size: 20, weight: .bold))
                    .kerning(-0.2)
                Text("routes")
            }
            .frame(height: 45)
            .frame(maxWidth: .infinity)
            .overlay(
                Rectangle()
                    .frame(width: 1),
                alignment: .trailing
            )
            
            NavigationLink(value: ProfileNavigation.friends(viewModel.user)) {
                HStack(spacing: 10) {
                    Text(String(viewModel.user.friends.count))
                        .font(.system(size: 20, weight: .bold))
                        .kerning(-0.2)
                    Text("friends")
                }
                .foregroundColor(Color.black)
                .frame(height: 45)
                .frame(maxWidth: .infinity)
            }
        }
    }
    
    private var loader: some View {
        HStack(spacing: 15) {
            Circle()
                .fill(Color.black.opacity(0.05))
                .frame(height: 120)
                .modifier(ShimmerEffect())
            
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Color(Color.black.opacity(0.05))
                            .frame(width: 100, height: 24)
                            .loading(isLoading: true)
                        Color(Color.black.opacity(0.05))
                            .frame(width: 100, height: 16)
                            .loading(isLoading: true)
                    }
                    
                    Spacer()
                }
                
                HStack(spacing: 0) {
                    Color(Color.black.opacity(0.05))
                        .frame(width: 75, height: 24)
                        .loading(isLoading: true)
                        .frame(height: 45)
                        .frame(maxWidth: .infinity)
                        .overlay(
                            Rectangle()
                                .frame(width: 1),
                            alignment: .trailing
                        )
                    
                    Color(Color.black.opacity(0.05))
                        .frame(width: 75, height: 24)
                        .loading(isLoading: true)
                        .frame(height: 45)
                        .frame(maxWidth: .infinity)
                }
            }
        }
    }
}

#Preview {
    ProfileHeader(viewModel: ProfileViewModel(user: MockData.Users[0]))
        .environmentObject(AuthController(testProfile: false))
        .padding()
}
