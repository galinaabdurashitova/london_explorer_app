//
//  ProfileStatIcons.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 25.08.2024.
//

import Foundation
import SwiftUI

struct ProfileStatIcons: View {
    enum StatIconType: CaseIterable {
        case awards
        case finishedRoutes
        case collectables
        
        var iconName: String {
            switch self {
            case .awards:           return "Trophy3DIcon"
            case .finishedRoutes:   return "Route3DIcon"
            case .collectables:     return "Treasures3DIcon"
            }
        }
        
        var word: String {
            switch self {
            case .awards:           return "awards"
            case .finishedRoutes:   return "routes finished"
            case .collectables:     return "collectables"
            }
        }
        
        var colour: Color {
            switch self {
            case .awards:           return Color.redAccent
            case .finishedRoutes:   return Color.greenAccent
            case .collectables:     return Color.blueAccent
            }
        }
        
        func getNavigation(user: User) -> ProfileNavigation {
            switch self {
            case .awards:           return ProfileNavigation.awards(user)
            case .finishedRoutes:   return ProfileNavigation.finishedRoutes(user)
            case .collectables:     return ProfileNavigation.collectables(user)
            }
        }
        
        func getNumber(user: User) -> Int {
            switch self {
            case .awards:           return user.awards.count
            case .finishedRoutes:   return user.finishedRoutes.count
            case .collectables:     return user.collectables.count
            }
        }
    }
    
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
            ForEach(StatIconType.allCases, id: \.self) { iconType in
                NavigationLink(value: iconType.getNavigation(user: viewModel.user)) {
                    statIcon(icon: iconType.iconName, number: iconType.getNumber(user: viewModel.user), word: iconType.word, colour: iconType.colour)
                }
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
