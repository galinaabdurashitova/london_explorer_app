//
//  MyProfileView.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 21.08.2024.
//

import Foundation
import SwiftUI

struct MyProfileView: View {
    @EnvironmentObject var auth: AuthController
    @EnvironmentObject var currentRoute: CurrentRouteManager
    @EnvironmentObject var awards: AwardsObserver
    
    var body: some View {
        NavigationStack {
            ProfileView(user: auth.profile, loadUnpublished: true)
                .appNavigation()
                .onAppear {
                    awards.checkAward(for: .profileOpened, user: auth.profile)
                }
        }
    }
}

#Preview {
    MyProfileView()
        .environmentObject(AuthController(testProfile: true))
        .environmentObject(CurrentRouteManager())
        .environmentObject(GlobalSettings())
        .environmentObject(AwardsObserver())
}
