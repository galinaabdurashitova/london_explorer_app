//
//  RouteProgressView.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 31.05.2024.
//

import Foundation
import SwiftUI

struct RouteProgressView: View {
    @Binding var routeProgress: RouteProgress
    @Binding var user: User?
    
    init(routeProgress: Binding<RouteProgress>, user: Binding<User?> = .constant(nil)) {
        self._routeProgress = routeProgress
        self._user = user
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack (spacing: 3) {
                HStack (spacing: 10) {
                    ZStack (alignment: .topLeading) {
                        Image(uiImage: routeProgress.route.image)
                            .roundedHeightFrame(height: 120)
                        
                        Image("Route3DIcon")
                            .icon(size: 60)
                            .padding(.all, -17)
                    }
                    .frame(width: (geometry.size.width - 45) / 2, height: 120)
                    
                    VStack (alignment: .leading, spacing: 8) {
                        if let user = self.user {
                            HStack (spacing: 4) {
                                user.image
                                    .profilePicture(size: 22)
                                Text(user.name)
                                    .font(.system(size: 14, weight: .bold))
                                Text("is on a")
                                    .font(.system(size: 14, weight: .light))
                            }
                        }
                        
                        Text(routeProgress.route.name)
                            .sectionCaption()
                        
                        VStack (alignment: .leading, spacing: 0) {
                            HStack {
                                Text(String(routeProgress.collectables) + "/" + String(routeProgress.route.collectables))
                                    .foregroundColor(Color.redDark)
                                    .font(.system(size: 14, weight: .black))
                                Text("collectables")
                                    .font(.system(size: 14, weight: .light))
                                    .opacity(0.8)
                            }
                            
                            HStack {
                                Text(String(routeProgress.stops) + "/" + String(routeProgress.route.stops.count))
                                    .foregroundColor(Color.redDark)
                                    .font(.system(size: 14, weight: .black))
                                Text("stops")
                                    .font(.system(size: 14, weight: .light))
                                    .opacity(0.8)
                            }
                        }
                    }
                    .frame(height: 120)
                }
                
                RouteProgressBar(num: $routeProgress.stops, total: routeProgress.route.stops.count)
            }
            .padding(20)
        }
        .frame(height: 200)
        .overlay(
            RoundedRectangle(cornerRadius: 8.0)
                .stroke(self.user == nil ? Color.redAccent : Color.blueAccent, lineWidth: 2.0)
        )
    }
}

#Preview {
    VStack (spacing: 25) {
        RouteProgressView(
            routeProgress: Binding<RouteProgress> (
                get: { return MockData.RouteProgress[0] },
                set: { _ in }
            )
        )
        RouteProgressView(
            routeProgress: Binding<RouteProgress> (
                get: { return MockData.RouteProgress[1] },
                set: { _ in }
            ),
            user: Binding<User?> (
                get: { return MockData.Users[0] },
                set: { _ in }
            )
        )
    }
    .padding()
}
