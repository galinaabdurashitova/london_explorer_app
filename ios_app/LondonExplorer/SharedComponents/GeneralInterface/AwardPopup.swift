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
    @State var isSaving: Bool = false
    
    var body: some View {
        ZStack {
            Color.white.opacity(0.1)
                .edgesIgnoringSafeArea(.all)
            
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
                    }
                    .padding(.top, 15)
                    
                    ButtonView(text: .constant("Hooray!"), colour: Color.blueAccent, textColour: Color.white, size: .L, isLoading: Binding(get: { awards.isSaving || auth.isFetchingUser }, set: { _ in })) {
                        Task {
                            await awards.saveAwards(user: auth.profile)
                            await auth.reloadUser()
                        }
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(30)
                .shadow(radius: 2)
            }
            .padding(.horizontal)
            .padding(.bottom, 30)
            
            ConfettiAnimation()
                .ignoresSafeArea()
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(.ultraThinMaterial)
    }
}

#Preview {
    ZStack {
        Image("BigBen")
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        AwardPopup()
            .environmentObject(AuthController())
            .environmentObject(AwardsObserver())
    }
}
