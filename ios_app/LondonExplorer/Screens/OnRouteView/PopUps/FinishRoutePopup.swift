//
//  FinishRoutePopup.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 22.07.2024.
//

import Foundation
import SwiftUI

struct FinishRoutePopup: View {
    @Binding var isOpen: Bool
    @State var awards: [User.UserAward] = []
    @State var action: () -> Void
    
    var body: some View {
        ZStack {
            Color.white.opacity(0.1)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    isOpen = false
                }
            
            VStack {
                VStack(spacing: 10) {
                    VStack(spacing: 20) {
                        Text("Congratulations!\nYou've finished the route")
                            .multilineTextAlignment(.center)
                            .font(.system(size: 20, weight: .medium))
                            .opacity(1)
                        
                        if awards.isEmpty {
                            Image("Confetti3DIcon")
                        } else {
                            VStack(spacing: 5) {
                                Text("You got \(awards.count <= 1 ? "an" : String(awards.count)) award\(awards.count > 1 ? "s" : "")!")
                                    .font(.system(size: 18))
                                    .opacity(0.7)
                                
                                TabView {
                                    ForEach(awards, id: \.self) { award in
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
                    }
                    .padding(.top, 15)
                    
                    ButtonView(text: .constant("Hooray!"), colour: Color.blueAccent, textColour: Color.white, size: .L) {
                        action()
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
        FinishRoutePopup(isOpen: .constant(true), awards: MockData.Users[0].awards) {
            
        }
    }
}
