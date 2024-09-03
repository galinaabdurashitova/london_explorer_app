//
//  StartRouteGreeting.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 22.07.2024.
//

import Foundation
import SwiftUI

struct StartRouteGreeting: View {
    @State var text: String
    @State var subText: String = ""
    @State var actionGo: () -> Void
    @State var actionCancel: () -> Void
    
    var body: some View {
        ZStack {
            Color.white.opacity(0.1)
                .edgesIgnoringSafeArea(.all)
                .background(.ultraThinMaterial)
            
            window
        }
    }
    
    private var window: some View {
        VStack(spacing: 10) {
            windowContent
            
            ButtonView(
                text: .constant("Let's go!"),
                colour: Color.blueAccent,
                textColour: Color.white,
                size: .L
            ) {
                actionGo()
            }
            ButtonView(
                text: .constant("Cancel"),
                colour: Color.redDark,
                textColour: Color.white,
                size: .L
            ) {
                actionCancel()
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(30)
        .shadow(radius: 2)
        .padding(.horizontal)
    }
    
    private var windowContent: some View {
        VStack(spacing: 20) {
            Text(text)
                .multilineTextAlignment(.center)
                .font(.system(size: 20, weight: .semibold))
                .opacity(1.0)
            
            Text(subText)
                .multilineTextAlignment(.center)
                .font(.system(size: 18))
                .opacity(0.7)
            
            Image("Route3DIcon")
        }
        .padding(.all, 15)
    }
}

#Preview {
    ZStack {
        Image("BigBen")
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        
        Color.white.opacity(0.1)
            .edgesIgnoringSafeArea(.all)
            .background(.ultraThinMaterial)
        
        StartRouteGreeting(
            text: "You're about to start the route! Get ready!",
            subText: "You're about to start the route! Get ready!"
        ) {
            
        } actionCancel: {
            
        }
    }
}
