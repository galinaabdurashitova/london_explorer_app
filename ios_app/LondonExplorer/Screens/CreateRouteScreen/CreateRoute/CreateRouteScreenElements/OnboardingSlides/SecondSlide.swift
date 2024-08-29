//
//  SecondSlide.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 29.08.2024.
//

import Foundation
import SwiftUI

struct SecondSlide: View {
    @State private var isAnimating = true
    
    var body: some View {
        VStack(spacing: 35) {
            Text("First select attractions for your route")
                .font(.system(size: 18, weight: .medium))
                .multilineTextAlignment(.center)
            
            VStack {
                attractionCard(attraction: MockData.Attractions[0], index: 1, bool: true)
                    .overlay(
                        Rectangle()
                            .frame(height: 1),
                        alignment: .bottom
                    )
                attractionCard(attraction: MockData.Attractions[1], index: 2, bool: false)
            }
            .onAppear {
                withAnimation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
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
    
    private func attractionCard(attraction: Attraction, index: Int, bool: Bool) -> some View {
        HStack (spacing: 5) {
            AttractionCard(attraction: Binding(get: { attraction }, set: { _ in }))
            
            
            ZStack {
                Image(systemName: "circle")
                    .icon(size: 35, colour: Color.black.opacity(0.5))
                    .fontWeight(.ultraLight)
                
                Text(String(index))
                    .frame(width: 35, height: 35)
                    .background(Color.redAccent)
                    .cornerRadius(100)
                    .foregroundColor(Color.white)
                    .font(.system(size: 18, weight: .bold))
                    .opacity(isAnimating && bool ? 1 : isAnimating || bool ? 0 : 1)
            }
        }
        .padding(.vertical, 10)
    }
}

#Preview {
    OnboardingCarousel()
        .padding()
}
