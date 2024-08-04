//
//  BackButton.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 10.06.2024.
//

import Foundation
import SwiftUI

struct BackButton: View {
    @State var text: String?
    @State var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            if let text = text {
                HStack (spacing: 10) {
                    Image(systemName: "chevron.left")
                    Text(text)
                }
                .frame(height: 40)
                .font(.system(size: 16, weight: .regular))
            } else {
                HStack (spacing: 10) {
                    Image(systemName: "chevron.left")
                }
                .frame(height: 40)
                .font(.system(size: 16, weight: .medium))
                .padding(.horizontal, 15)
                .background(Color.white)
                .cornerRadius(90)
            }
        }
    }
}

#Preview {
    Group {
        BackButton(text: "Back") { }
    }
    .padding()
    .background(Color.gray)
}
