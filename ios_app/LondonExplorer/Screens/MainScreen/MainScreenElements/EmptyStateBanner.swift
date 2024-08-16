//
//  EmptyStateBanner.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 31.05.2024.
//

import Foundation
import SwiftUI

struct EmptyStateBanner: View {
    
    var body: some View {
        VStack (alignment: .leading, spacing: 20) {
            HStack {
                Text("Hello Traveler!")
                    .font(.system(size: 24, weight: .medium))
                    .kerning(-0.2)
                Spacer()
                Image("Bus3DIcon")
                    .icon(size: 60)
                    .padding(.top, -10)
            }
            
            Text("It looks like you are not connected to the internet now🥲 You’ll be able to see our amazing routes after you connect!")
            Text("Don’t worry, the app will be available offline once you download any routes.")
            Text("Get ready for adventures!")
                .fontWeight(.bold)
                .foregroundColor(Color.redAccent)
        }
        .padding(.horizontal, 15.0)
        .padding(.vertical, 15.0)
        .background(Color.grayBackground)
        .cornerRadius(8)
    }
}

#Preview {
    EmptyStateBanner()
        .padding()
}
