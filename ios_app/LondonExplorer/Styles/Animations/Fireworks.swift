//
//  Fireworks.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 22.07.2024.
//

import Foundation
import SwiftUI

struct FireworksView: View {
    @State private var fireworks = [Firework]()
    @State private var particles = [Particle]()
    @State var screenSize: CGSize = UIScreen.main.bounds.size

    let colors: [Color] = [.red, .yellow, .blue, .green, .orange, .purple, .pink]

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            ForEach(fireworks) { firework in
                Circle()
                    .fill(firework.color)
                    .frame(width: firework.size, height: firework.size)
                    .position(firework.position)
            }
            ForEach(particles) { particle in
                Circle()
                    .fill(particle.color)
                    .frame(width: particle.size, height: particle.size)
                    .position(particle.position)
                    .opacity(particle.opacity)
            }
        }
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                launchFirework()
            }
        }
    }

    func launchFirework() {
        let initialPosition = CGPoint(x: CGFloat.random(in: 50...screenSize.width - 50), y: screenSize.height)
        
        let firework = Firework(
            color: colors.randomElement() ?? .white,
            size: 6,
            position: initialPosition
        )
        
        fireworks.append(firework)
        animateFirework(firework)
    }

    func animateFirework(_ firework: Firework) {
        let explosionHeight = CGFloat.random(in: screenSize.height * 0.3...screenSize.height * 0.7)
        
        withAnimation(Animation.easeOut(duration: 1.5)) {
            if let index = fireworks.firstIndex(of: firework) {
                fireworks[index].position = CGPoint(x: firework.position.x, y: explosionHeight)
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            if let index = fireworks.firstIndex(of: firework) {
                let explosionPosition = fireworks[index].position
                fireworks.remove(at: index)
                explodeFirework(at: explosionPosition, color: firework.color)
            }
        }
    }

    func explodeFirework(at position: CGPoint, color: Color) {
        let numberOfParticles = 20
        
        for _ in 0..<numberOfParticles {
            let angle = Double.random(in: 0...2 * .pi)
            let distance = CGFloat.random(in: 50...150)
            let xOffset = cos(angle) * distance
            let yOffset = sin(angle) * distance
            let particlePosition = CGPoint(x: position.x + xOffset, y: position.y + yOffset)
            
            let particle = Particle(
                color: color,
                size: CGFloat.random(in: 3...6),
                position: position,
                targetPosition: particlePosition,
                opacity: 1
            )
            
            particles.append(particle)
            
            withAnimation(Animation.easeOut(duration: 1.0)) {
                if let index = particles.firstIndex(of: particle) {
                    particles[index].position = particle.targetPosition
                    particles[index].opacity = 0
                }
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            particles.removeAll { $0.opacity == 0 }
        }
    }
}

struct Firework: Identifiable, Equatable {
    let id = UUID()
    var color: Color
    var size: CGFloat
    var position: CGPoint
}

struct Particle: Identifiable, Equatable {
    let id = UUID()
    var color: Color
    var size: CGFloat
    var position: CGPoint
    var targetPosition: CGPoint
    var opacity: Double
}

#Preview {
    FireworksView()
}
