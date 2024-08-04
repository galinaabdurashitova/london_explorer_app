//
//  RouteProgressStat.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 21.07.2024.
//

import Foundation
import SwiftUI

struct RouteProgressStat: View {
    enum Align {
        case left
        case right
    }
    
    @Binding var collectablesDone: Int
    @Binding var collectablesTotal: Int
    @Binding var stopsDone: Int
    @Binding var stopsTotal: Int
    @State var align: Align
    
    var body: some View {
        VStack (alignment: align == .left ? .leading : .trailing, spacing: 0) {
            HStack {
                if align == .right {
                    Text("collectables").word()
                }
                
                Text(String(collectablesDone) + "/" + String(collectablesTotal))
                    .stat()
                
                if align == .left {
                    Text("collectables").word()
                }
            }
            
            HStack {
                if align == .right {
                    Text("stops").word()
                }
                
                Text(String(stopsDone) + "/" + String(stopsTotal))
                    .stat()
                
                if align == .left {
                    Text("stops").word()
                }
            }
        }
    }
}

extension Text {
    func word() -> some View {
        self
            .font(.system(size: 14, weight: .light))
            .opacity(0.8)
    }
    
    func stat() -> some View {
        self                    
            .foregroundColor(Color.redDark)
            .font(.system(size: 14, weight: .black))
    }
}

#Preview {
    RouteProgressStat(
        collectablesDone: .constant(2),
        collectablesTotal: .constant(3),
        stopsDone: .constant(2),
        stopsTotal: .constant(4),
        align: .left
    )
}
