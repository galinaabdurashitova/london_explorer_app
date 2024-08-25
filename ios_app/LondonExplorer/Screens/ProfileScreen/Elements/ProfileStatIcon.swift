//
//  ProfileStatIcon.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 25.08.2024.
//

import Foundation
import SwiftUI

struct ProfileStatIcon: View {
    @State var icon: String
    @Binding var number: Int
    @State var word: String
    @State var colour: Color
    
    var body: some View {
        VStack(spacing: 0) {
            Image(icon)
                .resizable()
                .scaledToFit()
                .frame(width: 50)
            
            Text(String(number))
                .font(.system(size: 20, weight: .bold))
            Text(word)
                .font(.system(size: 14, weight: .light))

        }
        .foregroundColor(Color.black)
        .frame(width: (UIScreen.main.bounds.width - 60) / 3, height: (UIScreen.main.bounds.width - 60) / 3)
        .background(colour.opacity(0.2))
        .cornerRadius(8)
    }
}

#Preview {
    ProfileStatIcon(icon: "Trophy3DIcon", number: .constant(10), word: "awards", colour: Color.redAccent)
}
