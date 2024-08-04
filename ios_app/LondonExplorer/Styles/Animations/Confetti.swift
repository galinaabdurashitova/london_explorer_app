//
//  Confetti.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 22.07.2024.
//

import Foundation
import SwiftUI

struct ConfettiAnimation: View {
    @State private var startAnimation = false
    private let confettiCount = 100
    @State private var animationAmount = Double.random(in: 0...360)
    private var colors: [Color] = [.redAccent, .greenAccent, .blueAccent, .yellowAccent, .orange, .purple]
    
    var body: some View {
        ZStack {
            ForEach(0..<confettiCount, id: \.self) { index in
                ConfettiView
                    .offset(x: CGFloat.random(in: -150...150), y: self.startAnimation ? UIScreen.main.bounds.height : -UIScreen.main.bounds.height)
                    .scaleEffect(CGFloat.random(in: 0.5...1.5))
                    .animation(
                        Animation.linear(duration: Double.random(in: 6...10))
                            .repeatForever(autoreverses: false)
                            .delay(Double(index) * 0.05)
                    )
            }
        }
        .onAppear {
            self.startAnimation = true
        }
    }
    
    private var ConfettiView: some View {
        ConfettiShape
            .foregroundColor(colors.randomElement())
            .rotationEffect(.degrees(animationAmount))
            .animation(
                Animation.linear(duration: Double.random(in: 6...10))
//                    .repeatForever(autoreverses: false)
            )
            .onAppear {
                self.animationAmount = Double.random(in: 0...360)
            }
    }
    
    private var ConfettiShape: some View {
        Group {
            Rectangle()
                .frame(width: 10, height: 10)
            Circle()
                .frame(width: 10, height: 10)
        }
    }
}

#Preview {
    ZStack {
        Color.white.edgesIgnoringSafeArea(.all)
        ConfettiAnimation()
    }
}
