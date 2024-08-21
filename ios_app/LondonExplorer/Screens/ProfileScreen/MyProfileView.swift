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
    @Binding var tabSelection: Int
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .topTrailing) {
                ProfileView(user: auth.profile, tabSelection: $tabSelection)
            }
            .appNavigation(tab: $tabSelection)
        }
    }
}

#Preview {
    MyProfileView(tabSelection: .constant(4))
        .environmentObject(AuthController(testProfile: true))
        .environmentObject(CurrentRouteManager())
}
