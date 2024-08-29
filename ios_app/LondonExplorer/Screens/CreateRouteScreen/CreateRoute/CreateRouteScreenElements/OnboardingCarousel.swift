//
//  OnboardingCarousel.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 29.08.2024.
//

import Foundation
import SwiftUI

struct OnboardingCarousel: View {
    
    var body: some View {
        TabView {
            FirstSlide()
            
            SecondSlide()
            
            ThirdSlide()
            
            FourthSlide()
            
            FifthSlide()
            
            SixthSlide()
        }
        .tabViewStyle(PageTabViewStyle())
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
    }
}

#Preview {
    OnboardingCarousel()
        .padding()
}
