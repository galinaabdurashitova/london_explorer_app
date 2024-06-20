//
//  ButtonView.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 09.06.2024.
//

import Foundation
import SwiftUI

struct ButtonView: View {
    public enum ButtonSize {
        case M
        case L
    }
    
    @Binding var text: String
    var colour: Color
    var textColour: Color
    var size: ButtonSize = .L
    @Binding var disabled: Bool
    @State var action: () -> Void
    var noButton: Bool = false
    
    init(text: Binding<String>, colour: Color, textColour: Color, size: ButtonSize, disabled: Binding<Bool> = .constant(false), action: @escaping () -> Void) {
        _text = text
        self.colour = colour
        self.textColour = textColour
        self.size = size
        _disabled = disabled
        self.action = action
    }
    
    init(text: Binding<String>, colour: Color, textColour: Color, size: ButtonSize, disabled: Binding<Bool> = .constant(false)) {
        _text = text
        self.colour = colour
        self.textColour = textColour
        self.size = size
        _disabled = disabled
        self.action = { }
        self.noButton = true
    }
    
    init(text: Binding<String>, size: ButtonSize, disabled: Binding<Bool> = .constant(true)) {
        _text = text
        self.colour = Color.black.opacity(0.05)
        self.textColour = Color.black.opacity(0.1)
        self.size = size
        _disabled = disabled
        self.action = { }
    }
    
    var body: some View {
        if !noButton {
            Button(action: action) {
                Text(text)
                    .foregroundColor(disabled ? Color.black.opacity(0.1) : textColour.opacity(0.7))
                    .font(.system(size: 15, weight: .bold))
                    .padding()
                    .frame(width: size == ButtonSize.L ? UIScreen.main.bounds.width * 0.8 : UIScreen.main.bounds.width / 2 - 25)
                    .background(disabled ? Color(red: 0.949, green: 0.949, blue: 0.949) : colour)
            }
            .background(Color.white)
            .cornerRadius(10)
            .disabled(disabled)
        } else {
            HStack {
                Text(text)
                    .foregroundColor(disabled ? Color.black.opacity(0.1) : textColour.opacity(0.7))
                    .font(.system(size: 15, weight: .bold))
                    .padding()
                    .frame(width: size == ButtonSize.L ? UIScreen.main.bounds.width * 0.8 : UIScreen.main.bounds.width / 2 - 25)
                    .background(disabled ? Color(red: 0.949, green: 0.949, blue: 0.949) : colour)
            }
            .background(Color.white)
            .cornerRadius(10)
        }
    }
}

#Preview {
    ButtonView(
        text: Binding<String> (
            get: { return "Button" },
            set: { _ in }
        ),
        colour: Color.red,
        textColour: Color.white,
        size: .L,
        action: { } 
    )
    .padding()
}
