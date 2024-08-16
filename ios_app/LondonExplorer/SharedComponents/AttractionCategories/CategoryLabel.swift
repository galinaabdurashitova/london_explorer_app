//
//  CategoryLabel.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 09.06.2024.
//

import Foundation
import SwiftUI

struct CategoryLabel: View {
    @State var category: Attraction.Category
    @Binding var disabled: Bool
    
    init(category: Attraction.Category, disabled: Binding<Bool> = .constant(false)) {
        self.category = category
        _disabled = disabled
    }
    
    var body: some View {
        Text(category.rawValue.uppercased())
            .font(.system(size: 10, weight: .bold))
            .padding(.all, 7)
            .foregroundColor(disabled ? Color.black.opacity(0.5) : Color.black.opacity(0.5))
            .background(disabled ? Color.clear : category.colour.opacity(0.7))
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(disabled ? category.colour.opacity(0.7) : Color.clear)
            )
    }
}

#Preview {
    CategoryLabel(
        category: .cultural,
        disabled: Binding<Bool> (
            get: { return false },
            set: { _ in }
        )
    )
    .padding()
}
