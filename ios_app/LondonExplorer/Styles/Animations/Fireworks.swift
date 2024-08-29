//
//  Fireworks.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 22.07.2024.
//

import Foundation
import SwiftUI

struct Fireworks: View {
    @State private var animate: Bool = false
    @State private var opacity: Double = 1

    let colors: [Color] = [.red, .blue, .green, .yellow, .orange, .pink, .purple, .cyan]
    let confettiCount = 60

    var body: some View {
        ZStack {
            ForEach(0..<confettiCount, id: \.self) { index in
                ConfettiPiece(color: colors[index % colors.count])
                    .rotationEffect(Angle.degrees(animate ? Double.random(in: 0...360) : 0))
                    .offset(x: animate ? randomOffset().width : 0, y: animate ? randomOffset().height : 0)
                    .scaleEffect(animate ? 2 : 0.1)
                    .opacity(opacity)
                    .animation(
                        Animation.easeOut(duration: 2.5).delay(Double(index) * 0.02),
                        value: animate
                    )
            }
        }
        .onAppear {
            animate.toggle()
            withAnimation(Animation.easeInOut(duration: 1.5).delay(0.5)) {
                opacity = 0
            }
        }
    }

    func randomOffset() -> CGSize {
        let rangeX: ClosedRange<CGFloat> = -150...150
        let rangeY: ClosedRange<CGFloat> = -200...200
        return CGSize(width: CGFloat.random(in: rangeX), height: CGFloat.random(in: rangeY))
    }
}

struct ConfettiPiece: View {
    let color: Color

    var body: some View {
        Group {
            Rectangle()
                .fill(color)
                .frame(width: 30, height: 15)
        }
    }
}

#Preview {
    Fireworks()
}
