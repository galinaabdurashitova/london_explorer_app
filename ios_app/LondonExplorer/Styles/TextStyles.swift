//
//  TextStyles.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 30.05.2024.
//

import Foundation
import SwiftUI

extension Text {

    func sectionCaption() -> some View {
        self
            .font(.system(size: 20, weight: .semibold))
            .kerning(-0.2)
            .lineLimit(2)
            .truncationMode(.tail)
    }

    func sectionSubCaption() -> some View {
        self
            .font(.system(size: 14))
            .opacity(0.5)
    }
    
    func headline() -> some View {
        self
            .font(.system(size: 14, weight: .medium))
    }
    
    func subheadline() -> some View {
        self
            .font(.system(size: 14))
            .opacity(0.5)
            .lineLimit(2)
            .truncationMode(.tail)
    }
    
    func screenHeadline() -> some View {
        self
            .font(.system(size: 24, weight: .semibold))
            .kerning(-0.2)
            .lineLimit(2)
            .truncationMode(.tail)
    }
    
    func screenSubheadline() -> some View {
        self
            .font(.system(size: 16, weight: .medium))
            .lineLimit(2)
            .truncationMode(.tail)
    }
    
    func label() -> some View {
        self
            .font(.system(size: 14, weight: .light))
            .foregroundColor(Color.black.opacity(0.5))
            .padding(.vertical, 6)
            .padding(.horizontal, 8)
            .background(Color.black.opacity(0.05))
            .cornerRadius(20)
    }
}

#Preview {
    VStack(spacing: 10) {
        Text("This is some text")
            .sectionCaption()
        
        Text("This is some text")
            .sectionSubCaption()
        
        Text("This is some text")
            .headline()
        
        Text("This is some text")
            .subheadline()
        
        Text("This is some text")
            .screenHeadline()
        
        Text("This is some text")
            .screenSubheadline()
        
        Text("This is some text")
            .label()
    }
}
