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
    
    var body: some View {
        HStack {
            Text("We couldn’t download \(text)\nMaybe try again?")
                .font(.system(size: 16))
                .opacity(0.5)
            
            Spacer()
            
            Button(action: {
                // Update
            }) {
                Image(systemName: "arrow.triangle.2.circlepath")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 35)
                    .frame(width: 50, height: 50)
                    .background(Color.white)
                    .cornerRadius(100)
                    .foregroundColor(Color.black)
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
    WidgetError(text: "friends feed")
        .padding()
}
