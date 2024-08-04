//
//  JustifiedText.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 04.08.2024.
//

import Foundation
import SwiftUI

struct TextView: UIViewRepresentable {
    var text: String
    
    init(_ text: String) {
        self.text = text
    }
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)
        textView.textAlignment = .justified
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
    }
}

#Preview {
    TextView("Some really really long text. And another sentence to see the justification. Some really really long text. Some really really long text. Some really really long text. Some really really long text. ")
        .padding()
}
