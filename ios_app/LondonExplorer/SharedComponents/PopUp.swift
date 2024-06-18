//
//  PopUp.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 13.06.2024.
//

import Foundation
import SwiftUI

extension View {
    func popup(isPresented: Binding<Bool>, text: String, buttonText: String, action: @escaping () -> Void) -> some View {
        self
            .overlay {
                if isPresented.wrappedValue {
                    PopUp(isOpen: isPresented, text: text, buttonText: buttonText, action: action)
                }
            }
    }
}

struct PopUp: View {
    @Binding var isOpen: Bool
    @State var text: String
    @State var buttonText: String
    @State var action: () -> Void
    @State private var yOffset: CGFloat = UIScreen.main.bounds.height
    
    var body: some View {
        VStack {
            Spacer()
            
            VStack(spacing: 10) {
                VStack(spacing: 20) {
                    Text(text)
                        .multilineTextAlignment(.center)
                        .font(.system(size: 20, weight: .medium))
                        .opacity(0.7)
                    
                    Image(systemName: "questionmark.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 75, height: 75)
                        .padding(.all, 15)
                        .foregroundColor(Color.redAccent.opacity(0.7))
                        .background(Color.grayBackground)
                        .cornerRadius(8)
                }
                .padding(.all, 15)
                
                ButtonView(text: $buttonText, colour: Color.redDark, textColour: Color.white, size: .L) {
                    action()
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isOpen = false
                    }
                }
                ButtonView(text: .constant("Cancel"), colour: Color.blueAccent, textColour: Color.white, size: .L) {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isOpen = false
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
        .padding(.bottom, 50)
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(.ultraThinMaterial)
    }
}

#Preview {
    ZStack {
        Image("BigBen")
        PopUp(isOpen: .constant(true), text: "It's some question a user needs to confirm It's some question a user needs to confirm", buttonText: "Do it") {
            
        } 
    }
}
