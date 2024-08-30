//
//  AwardPopup.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 22.08.2024.
//

import Foundation
import SwiftUI

struct AwardPopup: View {
    @EnvironmentObject var auth: AuthController
    @EnvironmentObject var awards: AwardsObserver
    @EnvironmentObject var globalSettings: GlobalSettings
    @State var isSaving: Bool = false
    
    var body: some View {
        ZStack {
            Color.white.opacity(0.1)
                .edgesIgnoringSafeArea(.all)
            
            card
            
            ConfettiAnimation()
                .ignoresSafeArea()
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(.ultraThinMaterial)
    }
    
    private var card: some View {
        VStack {
            VStack(spacing: 10) {
                VStack(spacing: 20) {
                    Text("Congratulations!\nYou've got an award")
                        .multilineTextAlignment(.center)
                        .font(.system(size: 20, weight: .medium))
                        .opacity(1)
                    
                    if awards.newAwards.isEmpty {
                        Image("Confetti3DIcon")
                    } else {
                        awardsTabs
                    }
                }
                .padding(.top, 15)
                
                ButtonView(text: .constant("Hooray!"), colour: Color.blueAccent, textColour: Color.white, size: .L, isLoading: Binding(get: { awards.isSaving || auth.isFetchingUser }, set: { _ in })) {
                    self.saveAction()
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(30)
            .shadow(radius: 2)
        }
        .padding(.horizontal)
    }
    
    private var awardsTabs: some View {
        TabView {
            ForEach(awards.newAwards, id: \.self) { award in
                if let level = AwardLevel(rawValue: award.level) {
                    VStack {
                        level.getImage(award: award.type, sizeMultiply: 1.5)
                        
                        Text("A \(level.awardName) for")
                        Text(award.type.rawValue)
                            .sectionCaption()
                        Spacer()
                    }
                }
            }
        }
        .frame(height: 260)
        .tabViewStyle(PageTabViewStyle())
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
    }
    
    private func saveAction() {
        Task {
            await awards.saveAwards(user: auth.profile)
            await auth.reloadUser()
            globalSettings.setProfileReloadTrigger(to: true)
        }
    }
}

#Preview {
    ZStack {
        Image("BigBen")
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        AwardPopup()
            .environmentObject(AuthController())
            .environmentObject(AwardsObserver())
            .environmentObject(GlobalSettings())
    }
}
