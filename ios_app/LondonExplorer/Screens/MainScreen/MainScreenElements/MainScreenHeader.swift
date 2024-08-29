//
//  MainScreenHeader.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 02.06.2024.
//

import Foundation
import SwiftUI

struct MainScreenHeader: View {
    var scrollOffset: CGFloat
    var headerHeight: CGFloat
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack {
                    LondonExplorerLogo(scrollOffset: scrollOffset)
                    
                    Spacer()
                    
//                    Button(action: {
//                        // Open camera
//                    }) {
//                        Image(systemName: "camera.fill")
//                            .icon(size: 45, colour: Color.black)
//                    }
                }
                .padding(.horizontal, 20)
                .frame(height: headerHeight)
            }
            .offset(y: scrollOffset < 0 ? scrollOffset : 0)
        }
    }
}

#Preview {
    MainScreenHeader(scrollOffset: 0, headerHeight: 120)
        .padding()
}
