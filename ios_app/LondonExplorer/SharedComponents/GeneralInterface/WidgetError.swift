//
//  WidgetError.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 31.05.2024.
//

import Foundation
import SwiftUI

struct WidgetError: View {
    @State var text: String
    @State var isLoading: Bool = false
    @State var action: () -> Void
    
    var body: some View {
        HStack {
            Text("We couldn’t download \(text)\nMaybe try again?")
                .font(.system(size: 16))
                .opacity(0.5)
            
            Spacer()
            
            Button(action: {
                withAnimation(.linear(duration: 1).repeatForever(autoreverses: false)) {
                    isLoading = true
                }
                action()
                isLoading = false
            }) {
                Image(systemName: "arrow.triangle.2.circlepath")
                    .icon(size: 35, colour: Color.black)
                    .rotationEffect(Angle(degrees: isLoading ? 360 : 0))
                    .padding(.all, 8)
                    .background(Color.white)
                    .cornerRadius(100)
                    .fontWeight(.light)
            }
        }
        .padding(.horizontal, 15.0)
        .padding(.vertical, 20.0)
        .background(Color.grayBackground)
        .cornerRadius(8)
    }
}

#Preview {
    WidgetError(text: "friends feed") {
        
    }
    .padding()
}
