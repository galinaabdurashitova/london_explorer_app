//
//  LondonExplorerLogo.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 30.05.2024.
//

import Foundation
import SwiftUI

struct LondonExplorerLogo: View {
    var scrollOffset: CGFloat
    
    private var fontSize: CGFloat {
        max(24, 60 - (scrollOffset / 4))
    }
    
    var body: some View {
        VStack (alignment: .leading, spacing: -10) {
            Text("London")
                .font(.custom("Sirukota", size: fontSize))
                .foregroundColor(Color.redAccent)
            Text("Explorer")
                .font(.custom("Sirukota", size: fontSize + 4))
                .foregroundColor(Color.redAccent)
        }
        .onTapGesture(count: 4) {
            Server.localServer.toggle()
        }
    }
}

#Preview {
    LondonExplorerLogo(scrollOffset: 0)
}
