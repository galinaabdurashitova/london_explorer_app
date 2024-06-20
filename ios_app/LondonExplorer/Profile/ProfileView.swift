//
//  ProfileView.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 20.06.2024.
//

import Foundation
import SwiftUI

struct ProfileView: View {
    @StateObject var viewModel: ProfileViewModel = ProfileViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    ForEach($viewModel.savedRoutes, id: \.id) { route in
                        RouteCard(route: route, size: .M)
                    }
                }
                .padding(.all, 20)
            }
        }
    }
}

#Preview {
    ProfileView()
}
