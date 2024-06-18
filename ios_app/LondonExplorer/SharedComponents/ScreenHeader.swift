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
        _headline = headline
        _subheadline = subheadline
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
        headline: Binding<String> (
            get: { return "This is a screen header" },
            set: { _ in }
        ), subheadline: Binding<String?> (
            get: { return "This is a screen subheadline" },
            set: { _ in }
        )
    )
}
