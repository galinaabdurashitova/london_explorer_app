//
//  CollectableAnnotation.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 14.08.2024.
//

import Foundation
import SwiftUI

struct CollectableAnnotation: View {
    @Binding var color: Color?
    @Binding var index: Int?
    
    private var collectablesColors: [Color] = [.blueAccent, .yellowAccent, .greenAccent, .redAccent]
    
    init(color: Binding<Color?> = .constant(nil), index: Binding<Int?> = .constant(nil)) {
        self._color = color
        self._index = index
    }
    
    var body: some View {
        Image("Treasures3DIcon")
            .resizable()
            .scaledToFit()
            .frame(width: 25)
            .shadow(color: Color.white.opacity(0.8), radius: 4)
            .padding(.all, 10)
            .background(color ?? collectablesColors[(index ?? 0) % collectablesColors.count])
            .cornerRadius(100)
            .shadow(radius: 5)
    }
}

#Preview {
    CollectableAnnotation(color: .constant(Color.redAccent), index: .constant(0))
}
