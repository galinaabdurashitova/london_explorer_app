//
//  RouteClock.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 22.07.2024.
//

import Foundation
import SwiftUI

struct RouteClock: View {
    @Binding var routeProgress: RouteProgress
    @State var hours: String
    @State var minutes: String
    @State private var isColonVisible: Bool = true
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    init(routeProgress: Binding<RouteProgress>) {
        self._routeProgress = routeProgress
        self.hours = routeProgress.wrappedValue.elapsedTime().0
        self.minutes = routeProgress.wrappedValue.elapsedTime().1
    }
    
    var body: some View {
        VStack {
            Text(routeProgress.paused ? "Pause" : "On a route")
                .foregroundColor(routeProgress.paused ? Color.redAccent : Color.black)
                .font(.system(size: 14))
                .opacity(routeProgress.paused ? 1.0 : 0.5)
            
            HStack (spacing: 0) {
                Text(hours)
                    .sectionCaption()
                Text(":")
                    .sectionCaption()
                    .opacity(isColonVisible ? 1.0 : 0.0)
                    .animation(.easeInOut(duration: 0.5), value: isColonVisible)
                Text(minutes)
                    .sectionCaption()
            }
        }
        .onReceive(timer) { _ in
            if !routeProgress.paused {
                self.hours = routeProgress.elapsedTime().0
                self.minutes = routeProgress.elapsedTime().1
                
                withAnimation {
                    self.isColonVisible.toggle()
                }
            }
        }
    }
}

#Preview {
    RouteClock(routeProgress: .constant(MockData.RouteProgress[0]))
}
