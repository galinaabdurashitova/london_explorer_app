//
//  FifthSlide.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 29.08.2024.
//

import Foundation
import SwiftUI

struct FifthSlide: View {
    @State private var isAnimating = true
    
    var body: some View {
        VStack(spacing: 35) {
            Text("Publish your route when you're ready to share it with other users")
                .font(.system(size: 18, weight: .medium))
                .multilineTextAlignment(.center)
            
            VStack(spacing: 15) {
                Image(systemName: isAnimating ? "arrow.up.circle" : "checkmark.circle")
                    .font(.system(size: 70))
                    .foregroundColor(Color.blueAccent)
//                    .symbolEffect(.bounce, options: .repeating, value: isAnimating)
                    .contentTransition(.symbolEffect(.replace, options: .repeating))
                    .fontWeight(.light)
                Text("Publishing")
                    .fontWeight(.light)
                    .opacity(isAnimating ? 1 : 0.3)
            }
            .onAppear {
                startAnimationLoop()
            }
            
            Text("Keep in mind that you can edit or delete your route only when it's not published")
        }
        .frame(width: UIScreen.main.bounds.width - 80, height: 350)
        .padding()
        .background(Color.white)
        .cornerRadius(30)
        .shadow(radius: 3)
    }
    
    private func startAnimationLoop() {
        withAnimation(Animation.easeInOut(duration: 1.5)) {
            isAnimating.toggle()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            startAnimationLoop()
        }
    }
}

#Preview {
    FifthSlide()
        .padding()
}
