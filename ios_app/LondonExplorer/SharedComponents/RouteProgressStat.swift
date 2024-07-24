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
    
    @Binding var routeProgress: RouteProgress
    @State var align: Align
    
    var body: some View {
        VStack (alignment: align == .left ? .leading : .trailing, spacing: 0) {
            HStack {
                if align == .right {
                    Text("collectables").word()
                }
                
                Text(String(routeProgress.collectables) + "/" + String(routeProgress.route.collectables))
                    .stat()
                
                if align == .left {
                    Text("collectables").word()
                }
            }
            
            HStack {
                if align == .right {
                    Text("stops").word()
                }
                
                Text(String(routeProgress.stops) + "/" + String(routeProgress.route.stops.count))
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
        routeProgress: .constant(MockData.RouteProgress[0]),
        align: .left
    )
}
