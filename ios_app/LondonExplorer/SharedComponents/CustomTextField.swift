//
//  CustomTextField.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 16.06.2024.
//

import Foundation
import SwiftUI

struct CustomTextField: View {
    @Binding var fieldText: String
    @Binding var fillerText: String
    @Binding var textVariable: String
    @State private var internalText: String = ""
    @State private var borderColor: Color = Color.blueAccent
    @State private var shakeOffset: CGFloat = 0
    var height: Double?
    var maxLength: Int = 264
    
    var body: some View {
        VStack(alignment: .leading, spacing: 13) {
            Text(fieldText)
                .font(.system(size: 14, weight: .bold))
                .kerning(-0.2)
            
            TextField(fillerText, text: $internalText, axis: height != nil ? .vertical : .horizontal)
                .font(.system(size: 16, weight: .regular))
                .onChange(of: internalText) { newValue in
                    if newValue.count <= maxLength {
                        textVariable = newValue
                    } else {
                        shakeAndHighlight()
                        internalText = String(newValue.prefix(maxLength))
                    }
                }
            
            if let height = height {
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
