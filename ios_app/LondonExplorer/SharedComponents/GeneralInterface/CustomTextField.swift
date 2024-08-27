//
//  CustomTextField.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 16.06.2024.
//

import Foundation
import SwiftUI

struct CustomTextField: View {
    @Binding var fieldText: String?
    @Binding var fillerText: String
    @Binding var textVariable: String
    @State var isSecure: Bool
    @State private var borderColor: Color
    @State private var shakeOffset: CGFloat = 0
    @State var isVertical: Bool
    var height: Double?
    var maxLength: Int
    
    init(fieldText: Binding<String?> = .constant(nil), fillerText: Binding<String>, textVariable: Binding<String>, isSecure: Bool = false, borderColor: Color = Color.blueAccent, isVertical: Bool = false, height: Double? = nil, maxLength: Int = 264) {
        self._fieldText = fieldText
        self._fillerText = fillerText
        self._textVariable = textVariable
        self.isSecure = isSecure
        self.borderColor = borderColor
        self.isVertical = isVertical
        self.height = height
        self.maxLength = maxLength
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 13) {
            if let fieldText = fieldText {
                Text(fieldText)
                    .font(.system(size: 14, weight: .bold))
                    .kerning(-0.2)
            }
            
            if isSecure {
                SecureField(fillerText, text: $textVariable)
                    .font(.system(size: 16, weight: .regular))
                    .onChange(of: textVariable) { _, newValue in
                        if newValue.count > maxLength {
                            shakeAndHighlight()
                            textVariable = String(newValue.prefix(maxLength))
                        }
                    }
            } else {
                TextField(fillerText, text: $textVariable, axis: height != nil || isVertical ? .vertical : .horizontal)
                    .font(.system(size: 16, weight: .regular))
                    .onChange(of: textVariable) { _, newValue in
                        if newValue.count > maxLength {
                            shakeAndHighlight()
                            textVariable = String(newValue.prefix(maxLength))
                        }
                    }
            }
            
            if height != nil {
                Spacer()
            }
        }
        .offset(x: shakeOffset)
        .frame(height: CGFloat(height ?? 50))
        .padding(.all, 15)
        .overlay(
            RoundedRectangle(cornerRadius: 8.0)
                .stroke(borderColor, lineWidth: 1.0)
                .padding(.horizontal, 1)
        )
    }
    
    private func shakeAndHighlight() {
        withAnimation(.default) {
            borderColor = Color.redAccent
            shakeOffset = 10
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.default) {
                shakeOffset = -10
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(.default) {
                shakeOffset = 0
                borderColor = Color.blueAccent
            }
        }
    }
}


#Preview {
    CustomTextField(
        fieldText: .constant("Field Text"),
        fillerText: .constant("Filler text"),
        textVariable: .constant(""),
        maxLength: 2
    )
    .padding()
}
