//
//  ErrorPopUp.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 26.08.2024.
//

import Foundation
import SwiftUI

extension View {
    func error(text: String, isPresented: Binding<Bool>) -> some View {
        self
            .overlay {
                if isPresented.wrappedValue {
                    ErrorPopUp(text: text, isPresented: isPresented)
                }
            }
    }
}

struct ErrorPopUp: View {
    @State var text: String
    @Binding var isPresented: Bool
    
    var body: some View {
        ZStack {
            Color.white.opacity(0.1)
                .edgesIgnoringSafeArea(.all)
                .background(.ultraThinMaterial)
                .onTapGesture {
                    self.closePopUp()
                }
            
            errorWindow
        }
    }
    
    private var errorWindow: some View {
        VStack {
            VStack(spacing: 10) {
                VStack(spacing: 20) {
                    Text("An error occured")
                        .multilineTextAlignment(.center)
                        .font(.system(size: 20, weight: .semibold))
                        .opacity(1.0)
                    
                    Image("Exclamation3DIcon")
                    
                    Text(text)
                        .multilineTextAlignment(.center)
                        .font(.system(size: 18))
                        .opacity(0.7)
                }
                .padding(.all, 15)
                
                ButtonView(
                    text: .constant("OK"),
                    colour: Color.redDark,
                    textColour: Color.white,
                    size: .L
                ) {
                    self.closePopUp()
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(30)
            .shadow(radius: 2)
        }
        .padding(.horizontal)
    }
    
    private func closePopUp() {
        self.isPresented = false
    }
}

#Preview {
    Image("BigBen")
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .overlay(
            ErrorPopUp(
                text: "Error explanation",
                isPresented: .constant(true)
            )
        )
}
