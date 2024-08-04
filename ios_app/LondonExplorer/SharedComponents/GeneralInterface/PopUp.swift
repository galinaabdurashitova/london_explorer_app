//
//  PopUp.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 13.06.2024.
//

import Foundation
import SwiftUI

extension View {
    func popup(isPresented: Binding<Bool>, text: String, buttonText: String, iconName: String? = nil, invertButtons: Bool = false, action: @escaping () -> Void) -> some View {
        self
            .overlay {
                if isPresented.wrappedValue {
                    PopUp(isOpen: isPresented, text: text, buttonText: buttonText, iconName: iconName, invertButtons: invertButtons, action: action)
                }
            }
    }
}

struct PopUp: View {
    @Binding var isOpen: Bool
    @State var text: String
    @State var buttonText: String
    @State var iconName: String?
    @State var invertButtons: Bool = false
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
                    PopUp
                        .shadow(radius: 2)
                        .offset(y: yOffset)
                        .onAppear {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                yOffset = 0
                            }
                        }
                        .onChange(of: isOpen) { _, newValue in
                            withAnimation(.easeInOut(duration: 0.2)) {
                                yOffset = newValue ? 0 : UIScreen.main.bounds.height
                            }
                        }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(.ultraThinMaterial)
        }
    }
    
    var PopUp: some View {
        VStack(spacing: 10) {
            VStack(spacing: 20) {
                Text(text)
                    .multilineTextAlignment(.center)
                    .font(.system(size: 20, weight: .medium))
                    .opacity(0.7)
                
                if let icon = iconName {
                    Image(icon)
                } else {
                    Image(systemName: "questionmark.circle")
                        .icon(size: 75, colour: Color.redAccent.opacity(0.7))
                        .padding(.all, 15)
                        .background(Color.grayBackground)
                        .cornerRadius(8)
                }
            }
            .padding(.all, 15)
            
            ButtonView(
                text: $buttonText,
                colour: invertButtons ? Color.blueAccent : Color.redDark,
                textColour: Color.white,
                size: .L
            ) {
                action()
                withAnimation(.easeInOut(duration: 0.2)) {
                    isOpen = false
                }
            }
            ButtonView(
                text: .constant("Cancel"),
                colour: invertButtons ? Color.redDark : Color.blueAccent,
                textColour: Color.white,
                size: .L
            ) {
                withAnimation(.easeInOut(duration: 0.2)) {
                    isOpen = false
                }
            }
        }
        .padding(.all, 20)
        .background(Color.white)
        .cornerRadius(30)
    }
}

#Preview {
    ZStack {
        Image("BigBen")
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        PopUp(
            isOpen: .constant(true),
            text: "It's some question a user needs to confirm It's some question a user needs to confirm",
            buttonText: "Do it",
            iconName: "Route3DIcon",
            invertButtons: true
        ) {
            
        } 
    }
}
