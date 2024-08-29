//
//  LoadingView.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 02.06.2024.
//

import Foundation
import SwiftUI

struct LoadingView: View {
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 25) {
                VStack (spacing: 20) {
                    HStack {
                        VStack (alignment: .leading, spacing: 4) {
                            Color(Color.black.opacity(0.05))
                                .frame(width: 130, height: 24)
                                .loading(isLoading: true)
                            Color(Color.black.opacity(0.05))
                                .frame(width: 180, height: 20)
                                .loading(isLoading: true)
                        }
                        Spacer()
                    }
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack (alignment: .top, spacing: 12) {
                            ForEach(0..<3) { _ in
                                VStack (spacing: 5) {
                                    Color(Color.black.opacity(0.05))
                                        .frame(width: 165, height: 165)
                                        .loading(isLoading: true)
                                    Color(Color.black.opacity(0.05))
                                        .frame(width: 165, height: 20)
                                        .loading(isLoading: true)
                                    Color(Color.black.opacity(0.05))
                                        .frame(width: 165, height: 40)
                                        .loading(isLoading: true)
                                }
                            }
                        }
                    }
                    .scrollClipDisabled()
                    .scrollDisabled(true)
                }
                
                HStack {
                    VStack (alignment: .leading, spacing: 4) {
                        Color(Color.black.opacity(0.05))
                            .frame(width: 130, height: 24)
                            .loading(isLoading: true)
                        Color(Color.black.opacity(0.05))
                            .frame(width: 180, height: 20)
                            .loading(isLoading: true)
                    }
                    Spacer()
                }
                
                VStack {
                    ForEach(0..<3) { _ in
                        Color(Color.black.opacity(0.05))
                            .frame(width: geometry.size.width, height: 70)
                            .loading(isLoading: true)
                    }
                }
            }
        }
    }
}

#Preview {
    LoadingView()
        .padding()
}
