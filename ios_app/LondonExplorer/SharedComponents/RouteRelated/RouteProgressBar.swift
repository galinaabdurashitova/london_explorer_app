//
//  RouteProgressBar.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 31.05.2024.
//

import Foundation
import SwiftUI

struct RouteProgressBar: View {
    @Binding var num: Int
    @State var total: Int
    
    var body: some View {
        GeometryReader { geometry in
            ZStack (alignment: .leading) {
                Rectangle()
                    .frame(width: geometry.size.width, height: 8)
                    .cornerRadius(10)
                    .foregroundColor(Color.lightBlue)
                
                Rectangle()
                    .frame(width: geometry.size.width * self.getPercent(), height: 8)
                    .cornerRadius(10)
                    .foregroundColor(Color.redAccent)
                
                Image("Bus3DIcon")
                    .icon(size: 56)
                    .padding(.leading, geometry.size.width * self.getPercent() - 28)
                    .padding(.top, -5)
            }
        }
    }
    
    private func getPercent() -> Double {
        return Double(num) / Double(total)
    }
}

#Preview {
    RouteProgressBar(
        num: .constant(20),
        total: 100
    )
    .padding()
}
