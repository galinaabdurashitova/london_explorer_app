//
//  ThirdSlide.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 29.08.2024.
//

import Foundation
import SwiftUI

struct ThirdSlide: View {
    @State private var isAnimating = true
    
    var body: some View {
        VStack(spacing: 35) {
            Text("Select the order for the stops")
                .font(.system(size: 18, weight: .medium))
                .multilineTextAlignment(.center)
            
            VStack {
                attractionCard(attraction: MockData.Attractions[0], index: 1, bool: true)
                    .padding(.bottom, 10)
                    .offset(y: isAnimating ? 50 : 0)
                    .zIndex(1)
                
                attractionCard(attraction: MockData.Attractions[1], index: 2, bool: false)
            }
            .onAppear {
                withAnimation(Animation.easeOut(duration: 1.2).repeatForever(autoreverses: true)) {
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
        HStack {
            Image(uiImage: attraction.images[0])
                .roundedFrame(width: 70, height: 70)
            
            VStack (alignment: .leading, spacing: 2) {
                Text("Stop \(index)")
                    .font(.system(size: 14, weight: .light))
                    .opacity(0.5)
                    .lineLimit(2)
                    .truncationMode(.tail)
                    .multilineTextAlignment(.leading)
                Text(attraction.name)
                    .font(.system(size: 18, weight: .medium))
                    .kerning(-0.2)
                    .lineLimit(2)
                    .truncationMode(.tail)
                    .multilineTextAlignment(.leading)
            }
            
            Spacer()
            Image(systemName: bool ? "hand.tap.fill" : "quotelevel")
                .icon(size: 15, colour: Color.black.opacity(0.2))
        }
        .frame(width: 280)
        .padding(.all, 12)
        .background(bool ? Color.white : Color.gray.opacity(0.5))
        .overlay(
            RoundedRectangle(cornerRadius: 10.0)
                .stroke(
                    index % 4 == 1 ? Color.redAccent
                    : index % 4 == 2 ? Color.blueAccent
                    : index % 4 == 3 ? Color.yellowAccent
                    : Color.greenAccent,
                    lineWidth: 1.0
                )
        )
        .cornerRadius(10)
    }
}

#Preview {
    OnboardingCarousel()
        .padding()
}
