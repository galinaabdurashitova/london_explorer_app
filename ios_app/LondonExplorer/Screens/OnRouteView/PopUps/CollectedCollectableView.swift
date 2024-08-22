//
//  CollectedCollectableView.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 14.08.2024.
//

import Foundation
import SwiftUI

struct CollectedCollectableView: View {
    @EnvironmentObject var auth: AuthController
    @State var collectable: Collectable
    @State var alreadyHave: Bool
    @State var action: () -> Void
    
    var body: some View {
        ZStack {
            Color.white.opacity(0.1)
                .edgesIgnoringSafeArea(.all)
                .background(.ultraThinMaterial)
            
            VStack(spacing: 10) {
                VStack(spacing: 20) {
                    Text("You found")
                        .multilineTextAlignment(.center)
                        .font(.system(size: 18))
                        .opacity(0.7)
                        .padding(.bottom, -20)
                    
                    Text(collectable.rawValue)
                        .multilineTextAlignment(.center)
                        .font(.system(size: 24, weight: .semibold))
                    
                    collectable.image
                        .resizable()
                        .scaledToFit()
                        .frame(width: UIScreen.main.bounds.width - 110)
                        .cornerRadius(150)
                }
                .padding(.all, 15)
                
                ButtonView(
                    text: alreadyHave
                        ? .constant("I already have it")
                        : .constant("Collect!"),
                    colour: alreadyHave
                        ? Color.lightBlue
                        : Color.blueAccent,
                    textColour: alreadyHave
                        ? Color.black
                        : Color.white,
                    size: .L
                ) {
                    action()
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(30)
            .shadow(radius: 2)
            
            if !alreadyHave {
                Fireworks()
            }
        }
    }
}

#Preview {
    ZStack {
        Image("BigBen")
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        
        Color.white.opacity(0.1)
            .edgesIgnoringSafeArea(.all)
            .background(.ultraThinMaterial)
        
        CollectedCollectableView(collectable: Collectable.lions, alreadyHave: false) {
            
        }
        .environmentObject(AuthController())
    }
}
