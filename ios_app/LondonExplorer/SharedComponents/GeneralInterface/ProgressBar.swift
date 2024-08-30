//
//  ProgressBar.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 16.08.2024.
//

import Foundation
import SwiftUI

struct ProgressBar: View {
    @Binding var num: Double
    @Binding var total: Double
    @Binding var colour: Color
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(width: geometry.size.width)
                    .cornerRadius(10)
                    .foregroundColor(Color.lightBlue)
                
                Rectangle()
                    .frame(width: min(max(0, geometry.size.width * self.getPercent()), geometry.size.width))
                    .cornerRadius(10)
                    .foregroundColor(colour)
            }
        }
        .frame(height: 8)
    }
    
    private func getPercent() -> Double {
        return Double(num) / Double(total)
    }
}

#Preview {
    ProgressBar(
        num: .constant(90),
        total: .constant(100),
        colour: .constant(Color.blueAccent)
    )
    .padding()
}
