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
}

#Preview {
    VStack {
        Text("This is some text")
            .sectionCaption()
        
        Text("This is some text")
            .sectionSubCaption()
        
        Text("This is some text")
            .headline()
        
        Text("This is some text")
            .subheadline()
    }
}
