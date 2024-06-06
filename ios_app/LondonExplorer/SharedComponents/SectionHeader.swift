//
//  SectionHeader.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 30.05.2024.
//

import Foundation
import SwiftUI

struct SectionHeader: View {
    @Binding var headline: String
    @Binding var subheadline: String?
    
    init(headline: Binding<String>, subheadline: Binding<String?> = .constant(nil)) {
        _headline = headline
        _subheadline = subheadline
    }
    
    var body: some View {
        VStack (alignment: .leading, spacing: 4) {
            Text(headline)
                .sectionCaption()
            if let subheadline = subheadline {
                Text(subheadline)
                    .sectionSubCaption()
            }
        }
    }
}


#Preview {
    SectionHeader(
        headline: Binding<String> (
            get: { return "This is a section header" },
            set: { _ in }
        ), subheadline: Binding<String?> (
            get: { return "This is a section subheadline" },
            set: { _ in }
        )
    )
}
