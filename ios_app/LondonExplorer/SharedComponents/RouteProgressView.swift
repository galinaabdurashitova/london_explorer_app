//
//  RouteProgressView.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 31.05.2024.
//

import Foundation
import SwiftUI

struct RouteProgressView: View {
    @EnvironmentObject var auth: AuthController
    @Binding var routeProgress: RouteProgress
    @Binding var user: User?
    
    init(routeProgress: Binding<RouteProgress>, user: Binding<User?> = .constant(nil)) {
        self._routeProgress = routeProgress
        self._user = user
    }
    
    var body: some View {
        NavigationLink(destination: {
            OnRouteView(routeProgress: routeProgress)
                .environmentObject(auth)
        }) {
            VStack (alignment: .leading, spacing: 3) {
                HStack (spacing: 10) {
                    ZStack (alignment: .topLeading) {
                        Image(uiImage: routeProgress.route.image)
                            .roundedFrame(width: ((UIScreen.main.bounds.width - 90) * 0.5), height: 120)
                        
                        Image("Route3DIcon")
                            .icon(size: 60)
                            .padding(.all, -17)
                    }
                    
                    VStack (alignment: .leading, spacing: 8) {
                        if let user = self.user {
                            HStack (spacing: 4) {
                                Image(uiImage: user.image)
                                    .profilePicture(size: 22)
                                Text(user.name)
                                    .font(.system(size: 14, weight: .bold))
                                Text("is on a")
                                    .font(.system(size: 14, weight: .light))
                            }
                        }
                        
                        Text(routeProgress.route.name)
                            .sectionCaption()
                            .multilineTextAlignment(.leading)
                        
                        RouteProgressStat(routeProgress: $routeProgress, align: .left)
                    }
                    .foregroundColor(Color.black)
                    .frame(height: 120)
                }
                
                RouteProgressBar(num: $routeProgress.stops, total: routeProgress.route.stops.count)
            }
            .padding(20)
            .frame(height: 200)
            .overlay(
                RoundedRectangle(cornerRadius: 8.0)
                    .stroke(self.user == nil ? Color.redAccent : Color.blueAccent, lineWidth: 2.0)
            )
        }
        .disabled(user != nil)
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
    .environmentObject(AuthController())
    .padding()
}
