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
    @Binding var path: CodableMKRoute?
    
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
                            .icon(size: 25)
                            .scaleEffect(x: reversed ? -1 : 1, y: 1)
                        Text(String(format: "%.0f", time / 60) + " min")
                            .font(.system(size: 14, weight: .medium))
                    }
                } else {
                    Image(systemName: "xmark")
                        .icon(size: 20)
                }
            }
        }
    }
}

#Preview {
    PathConnection(
        isLoading: .constant(false),
        path: .constant(CodableMKRoute(from: MKRoute()))
    )
    .padding()
}
