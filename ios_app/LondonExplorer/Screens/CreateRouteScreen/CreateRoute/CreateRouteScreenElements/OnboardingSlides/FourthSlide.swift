//
//  FourthSlide.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 29.08.2024.
//

import Foundation
import SwiftUI

struct FourthSlide: View {
    @State private var isAnimating = true
    @State var emptyText: String = ""
    
    var body: some View {
        VStack(spacing: 35) {
            Text("Give your route a name and fill the description")
                .font(.system(size: 18, weight: .medium))
                .multilineTextAlignment(.center)
            
            VStack {
                CustomTextField(fieldText: .constant("Route Name"), fillerText: .constant("Type route name here..."), textVariable: $emptyText, maxLength: 64)
                    .disabled(true)
                    .offset(x: isAnimating ? 3 : -3)
                
                CustomTextField(fieldText: .constant("Route Description"), fillerText: .constant("Fill in route description..."), textVariable: $emptyText, height: 100, maxLength: 32000)
                    .disabled(true)
                    .offset(x: isAnimating ? -3 : 3)
            }
            .onAppear {
                withAnimation(Animation.bouncy(duration: 0.5).repeatForever(autoreverses: true)) {
                    isAnimating = false
                }
            }
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
