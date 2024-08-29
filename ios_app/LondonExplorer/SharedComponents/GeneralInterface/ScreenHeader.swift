//
//  ScreenHeader.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 07.06.2024.
//

import Foundation
import SwiftUI

struct ScreenHeader: View {
    @Binding var headline: String
    @Binding var subheadline: String?
    
    init(headline: Binding<String>, subheadline: Binding<String?> = .constant(nil)) {
        self._headline = headline
        self._subheadline = subheadline
    }
    
    var body: some View {
        VStack (alignment: .leading, spacing: 6) {
            Text(headline)
                .screenHeadline()
            if let subheadline = subheadline {
                Text(subheadline)
                    .screenSubheadline()
            }
        }
    }
}


#Preview {
    ScreenHeader(
        headline: .constant("This is a screen header"),
        subheadline: .constant("This is a screen subheadline")
    )
}
