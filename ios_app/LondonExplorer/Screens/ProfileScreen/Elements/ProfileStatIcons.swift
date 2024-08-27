//
//  ProfileStatIcons.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 25.08.2024.
//

import Foundation
import SwiftUI

struct ProfileStatIcons: View {
    @ObservedObject var viewModel: ProfileViewModel
    
    var body: some View {
        if viewModel.userLoading {
            loader
        } else {
            iconRow
        }
    }
    
    private var iconRow: some View {
        HStack(spacing: 10) {
            NavigationLink(value: ProfileNavigation.awards(viewModel.user)) {
                statIcon(icon: "Trophy3DIcon", number: viewModel.user.awards.count, word: "awards", colour: Color.redAccent)
            }
            
            NavigationLink(value: ProfileNavigation.finishedRoutes(viewModel.user)) {
                statIcon(icon: "Route3DIcon", number: viewModel.user.finishedRoutes.count, word: "routes finished", colour: Color.greenAccent)
            }
            
            NavigationLink(value: ProfileNavigation.collectables(viewModel.user)) {
                statIcon(icon: "Treasures3DIcon", number: viewModel.user.collectables.count, word: "collectables", colour: Color.blueAccent)
            }
        }
    }
    
    private func statIcon(icon: String, number: Int, word: String, colour: Color) -> some View {
        VStack(spacing: 0) {
            Image(icon)
                .resizable()
                .scaledToFit()
                .frame(width: 50)
            
            Text(String(number))
                .font(.system(size: 20, weight: .bold))
            Text(word)
                .font(.system(size: 14, weight: .light))
            
        }
        .foregroundColor(Color.black)
        .frame(width: (UIScreen.main.bounds.width - 60) / 3, height: (UIScreen.main.bounds.width - 60) / 3)
        .background(colour.opacity(0.2))
        .cornerRadius(8)
    }
    
    private var loader: some View {
        HStack(spacing: 10) {
            ForEach(0..<3) { _ in
                Color(Color.black.opacity(0.05))
                    .frame(width: (UIScreen.main.bounds.width - 60) / 3, height: (UIScreen.main.bounds.width - 60) / 3)
                    .cornerRadius(8)
                    .loading(isLoading: true)
            }
        }
    }
}

#Preview {
    ProfileStatIcons(viewModel: ProfileViewModel(user: MockData.Users[0]))
}
