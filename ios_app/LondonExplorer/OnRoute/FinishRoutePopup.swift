//
//  FinishRoutePopup.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 22.07.2024.
//

import Foundation
import SwiftUI

struct FinishRoutePopup: View {
    @Binding var isOpen: Bool
    @State var action: () -> Void
    @State private var yOffset: CGFloat = UIScreen.main.bounds.height
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                Color.white.opacity(0.1)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        isOpen = false
                    }
                
                VStack {
                    VStack(spacing: 10) {
                        VStack(spacing: 20) {
                            Text("Congratulations! You've finished the route")
                                .multilineTextAlignment(.center)
                                .font(.system(size: 20, weight: .medium))
                                .opacity(0.7)
                            
                            Image("Confetti3DIcon")
                        }
                        .padding(.all, 15)
                        
                        ButtonView(text: .constant("Hooray!"), colour: Color.blueAccent, textColour: Color.white, size: .L) {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                action()
//                                self.presentationMode.wrappedValue.dismiss()
                            }
                        }
                    }
                    .padding(.all, 20)
                    .background(Color.white)
                    .cornerRadius(30)
                    .shadow(radius: 2)
                    .offset(y: yOffset)
                    .onAppear {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            yOffset = 0
                        }
                    }
                    .onChange(of: isOpen) { newValue in
                        withAnimation(.easeInOut(duration: 0.2)) {
                            yOffset = newValue ? 0 : UIScreen.main.bounds.height
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
                
                ConfettiAnimation()
                    .ignoresSafeArea()
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(.ultraThinMaterial)
        }
    }
}

#Preview {
    ZStack {
        Image("BigBen")
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        FinishRoutePopup(isOpen: .constant(true)) {
            
        }
    }
}
