//
//  AwardsObserver.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 22.08.2024.
//

import Foundation
import SwiftUI

class AwardsObserver: ObservableObject {
    @Published var newAwards: [User.UserAward] = []
    @Published var isSaving: Bool = false
    
    @MainActor
    func checkAward(for trigger: AwardTypes.AwardTriggers, user: User) {
        withAnimation {
            self.newAwards = trigger.getAwards(user: user)
        }
        print("Awards checked")
    }
    
    @MainActor
    func saveAwards(user: User) async {
        self.isSaving = true
        if !self.newAwards.isEmpty {
            do {
                try await UsersService().saveUserAward(userId: user.id, awards: self.newAwards)
            } catch {
                print("Error saving awards")
            }
            withAnimation { newAwards = [] }
        }
        self.isSaving = false
    }
}
