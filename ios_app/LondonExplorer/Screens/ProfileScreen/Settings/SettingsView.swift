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
    @EnvironmentObject var awards: AwardsObserver
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 30) {
                HStack {
                    ScreenHeader(headline: .constant("Settings"))
                    Spacer()
                }
                
                ForEach(SettingsType.allCases, id: \.self) { setting in
                    setting.link(for: auth.profile)
                }
                
                Toggle("Use test data", isOn: $globalSettings.useMockData)
                    .padding(.trailing, 5)
                
                Button(action: self.signOut) {
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
        .navigationDestination(for: SettingsType.self) { value in
            SettingPage(setting: value)
        }
    }
    
    func signOut() {
        globalSettings.signOut()
        awards.signOut()
        auth.signOut()
    }
}

#Preview {
    SettingsView()
        .environmentObject(AuthController(testProfile: true))
        .environmentObject(GlobalSettings())
        .environmentObject(AwardsObserver())
}
