//
//  ActionBanner.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 23.07.2024.
//

import Foundation
import SwiftUI

struct ActionBanner: View {
    @State var text: String
    @State var actionText: String
    
    var body: some View {
        HStack {
            Text(text)
                .font(.system(size: 16))
                .foregroundColor(Color.black.opacity(0.5))
                .multilineTextAlignment(.leading)
            
            Spacer()
            
            HStack (spacing: 7) {
                Text(actionText)
                    .font(.system(size: 14, weight: .semibold))
                Image(systemName: "chevron.forward")
                    .icon(size: 10)
            }
            .foregroundColor(Color.black)
        }
        .padding(.horizontal, 15.0)
        .padding(.vertical, 20.0)
        .background(Color.lightBlue)
        .cornerRadius(8)
    }
}

#Preview {
    ActionBanner(text: "Some text", actionText: "More text")
}
