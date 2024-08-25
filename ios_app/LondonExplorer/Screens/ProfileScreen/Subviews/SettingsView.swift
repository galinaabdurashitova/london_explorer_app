//
//  SettingsView.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 07.08.2024.
//

import Foundation
import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var auth: AuthController
    @EnvironmentObject var globalSettings: GlobalSettings
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 25) {
                HStack {
                    ScreenHeader(headline: .constant("Settings"))
                    Spacer()
                }
                
                Toggle("Use test data", isOn: $globalSettings.useMockData)
                    .padding(.trailing, 5)
                
                Button(action: {
                    globalSettings.tabSelection = 0
                    globalSettings.searchTab = 0
                    auth.signOut()
                }) {
                    HStack {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                            .icon(size: 25, colour: Color.redAccent)
                        Text("Exit app")
                            .foregroundColor(Color.redAccent)
                        Spacer()
                    }
                }
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    SettingsView()
        .environmentObject(AuthController(testProfile: true))
        .environmentObject(GlobalSettings())
}
