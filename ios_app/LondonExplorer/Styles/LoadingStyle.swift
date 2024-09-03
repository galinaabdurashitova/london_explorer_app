//
//  LoadingStyle.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 02.06.2024.
//

import Foundation
import SwiftUI

extension View {
    
    @ViewBuilder
    func loading(isLoading: Bool) -> some View {
        if isLoading {
            self
                .overlay(
                    Color(Color(red: 0.95, green: 0.95, blue: 0.95))
                )
                .cornerRadius(8)
                .modifier(ShimmerEffect())
                .clipped()
        } else {
            self
        }
    }
}

struct ShimmerEffect: ViewModifier {
    @State private var isAnimating = false
    
    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geometry in
                    Rectangle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(
                                    colors: [
                                        Color.white.opacity(0.0),
                                        Color.white.opacity(0.4),
                                        Color.white.opacity(0.7),
                                        //Color.white.opacity(1.0),
                                        Color.white.opacity(0.4),
                                        Color.white.opacity(0.0)
                                    ]
                                ),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: 60)
                        .blur(radius: 10)
                        .mask(content)
                        .offset(x: isAnimating ? geometry.size.width : -geometry.size.width)
                        .animation(
                            Animation.linear(duration: 2.0).repeatForever(autoreverses: false),
                            value: isAnimating
                        )
                }
            )
            .onAppear {
                isAnimating = true
            }
    }
}

#Preview {
    Text("This is some text")
        .sectionCaption()
        .loading(isLoading: true)
        .frame(width: 130, height: 24)
}
