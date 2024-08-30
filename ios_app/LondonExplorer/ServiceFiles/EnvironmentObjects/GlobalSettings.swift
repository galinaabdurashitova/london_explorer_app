//
//  GlobalSettings.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 07.08.2024.
//

import Foundation
import SwiftUI

class GlobalSettings: ObservableObject {
    @Published var useMockData: Bool = false
    @Published var tabSelection: Int = 0
    @Published var searchTab: Int = 0
    
    @Published var favouriteRoutesReloadTrigger: Bool = true
    @Published var profileReloadTrigger: Bool = true
    
    @MainActor
    func signOut() {
        self.tabSelection = 0
        self.searchTab = 0
        self.favouriteRoutesReloadTrigger = true
        self.profileReloadTrigger = true
    }
    
    @MainActor
    func setProfileReloadTrigger(to value: Bool) {
        self.profileReloadTrigger = value
    }
    
    @MainActor
    func setFavouriteRoutesReloadTrigger(to value: Bool) {
        self.favouriteRoutesReloadTrigger = value
    }
    
    @MainActor
    func goToTab(_ tab: AppTabs) {
        self.tabSelection = tab.rawValue
    }
    
    @MainActor
    func goToSearchTab(_ tab: SearchTabs) {
        self.searchTab = tab.rawValue
    }
}
