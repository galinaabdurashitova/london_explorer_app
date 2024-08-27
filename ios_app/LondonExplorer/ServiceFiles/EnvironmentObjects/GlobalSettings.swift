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
    
    func signOut() {
        self.tabSelection = 0
        self.searchTab = 0
        self.favouriteRoutesReloadTrigger = true
        self.profileReloadTrigger = true
    }
}
