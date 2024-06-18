//
//  PathConnection.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 10.06.2024.
//

import Foundation
import SwiftUI
import MapKit

struct PathConnection: View {
    @Binding var isLoading: Bool
    @State var reversed: Bool = false
    @Binding var path: MKRoute?
    
    var body: some View {
        ZStack {
            Image("path")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: UIScreen.main.bounds.width * 0.62)
                .scaleEffect(x: reversed ? -1 : 1, y: 1)
            if isLoading {
                ProgressView()
            } else {
                if let time = path?.expectedTravelTime {
                    VStack (spacing: 0) {
                        Image("WalkiOSIcon")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 25)
                            .scaleEffect(x: reversed ? -1 : 1, y: 1)
                        Text(String(format: "%.0f", time / 60) + " min")
                            .font(.system(size: 14, weight: .medium))
                    }
                } else {
                    Image(systemName: "xmark")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20)
                }
            }
        }
    }
}

#Preview {
    PathConnection(
        isLoading: Binding<Bool> (
            get: { return false },
            set: { _ in }
        ),
        path: .constant(MKRoute())
    )
    .padding()
}
