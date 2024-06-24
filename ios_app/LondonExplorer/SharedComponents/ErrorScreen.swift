//
//  ErrorScreen.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 24.06.2024.
//

import Foundation
import SwiftUI

struct ErrorScreen: View {
    @State var action: () -> Void = { }
    
    var body: some View {
        VStack {
            Spacer()
            
            VStack(spacing: 40) {
                VStack(spacing: 10) {
                    Text("Error loading data")
                        .sectionCaption()
                    
                    Text("You can try again or come back a bit later")
                }
                
                Image("SadCloudSFIcon")
                    .icon(size: 100, colour: Color.black.opacity(0.3))
                    .padding()
                    .background(Color.black.opacity(0.05))
                    .cornerRadius(100)
                
                ButtonView(
                    text: .constant("Try again"),
                    colour: Color.lightBlue,
                    textColour: Color.black,
                    size: .L
                ) {
                    action()
                }
            }
            
            Spacer()
        }
    }
}

#Preview {
    ErrorScreen()
        .padding()
}
