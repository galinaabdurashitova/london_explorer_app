//
//  SixthSlide.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 29.08.2024.
//

import Foundation
import SwiftUI

struct SixthSlide: View {
    @State private var isAnimating = true
    
    var body: some View {
        VStack(spacing: 35) {
            NavigationLink(value: CreateRoutePath.routeStops) {
                ZStack {
                    Circle()
                        .foregroundColor(Color.white.opacity(0.7))
                        .shadow(color: Color.white.opacity(0.7), radius: isAnimating ? 3 : 10)
                    
                    ZStack (alignment: .bottomTrailing) {
                        Image("MapMarker3DIcon")
                            .icon(size: isAnimating ? 130 : 150)
                        
                        Image("Plus3DIcon")
                            .icon(size: isAnimating ? 50 : 70)
                    }
                    .padding(.bottom, -10)
                }
                .frame(width: 194, height: 194)
            }
            
            VStack(spacing: 0) {
                Text("Are you ready?")
                
                Text("Create new route now!")
                    .font(.system(size: 26, weight: .semibold))
                    .foregroundColor(Color.black)
                    .kerning(-0.2)
                    .padding(.vertical)
            }
        }
        .onAppear {
            withAnimation(Animation.easeIn(duration: 0.6).repeatForever(autoreverses: true)) {
                isAnimating = false
            }
        }
        .frame(width: UIScreen.main.bounds.width - 80, height: 350)
        .padding()
        .background(Color.redAccent.opacity(0.3))
        .cornerRadius(30)
    }
}

#Preview {
    OnboardingCarousel()
        .padding()
}
