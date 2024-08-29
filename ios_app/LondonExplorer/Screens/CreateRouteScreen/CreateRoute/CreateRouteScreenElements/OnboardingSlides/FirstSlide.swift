//
//  FirstSlide.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 29.08.2024.
//

import Foundation
import SwiftUI

struct FirstSlide: View {
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 35) {
            Text("Are you ready to\ncreate a route?")
                .font(.system(size: 20, weight: .bold))
                .multilineTextAlignment(.center)
            
            ZStack {
                Circle()
                    .fill(Color.redAccent.opacity(0.15))
                    .frame(width: 140)
                
                Image("Route3DIcon")
                    .offset(y: isAnimating ? -10 : 10)
                    .onAppear {
                        withAnimation(Animation.easeInOut(duration: 0.6).repeatForever(autoreverses: true)) {
                            isAnimating.toggle()
                        }
                    }
            }
            
            Text("Let's start!")
        }
        .frame(width: UIScreen.main.bounds.width - 80, height: 350)
        .padding()
        .background(Color.white)
        .cornerRadius(30)
        .shadow(radius: 3)
    }
}

#Preview {
    OnboardingCarousel()
        .padding()
}
