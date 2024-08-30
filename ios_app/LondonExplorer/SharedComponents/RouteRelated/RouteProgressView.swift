//
//  RouteProgressView.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 31.05.2024.
//

import Foundation
import SwiftUI

struct RouteProgressView: View {
    @Binding var image: String
    @Binding var routeName: String
    @Binding var collectablesDone: Int
    @Binding var collectablesTotal: Int
    @Binding var stopsDone: Int
    @Binding var stopsTotal: Int
    @Binding var user: User?
    
    init(image: Binding<String>, routeName: Binding<String>, collectablesDone: Binding<Int>, collectablesTotal: Binding<Int>, stopsDone: Binding<Int>, stopsTotal: Binding<Int>, user: Binding<User?> = .constant(nil)) {
        self._image = image
        self._routeName = routeName
        self._collectablesDone = collectablesDone
        self._collectablesTotal = collectablesTotal
        self._stopsDone = stopsDone
        self._stopsTotal = stopsTotal
        self._user = user
    }
    
    var body: some View {
        VStack (alignment: .leading, spacing: 3) {
            HStack (spacing: 10) {
                routeProgressImage
                
                routeProgressContent
            }
            
            RouteProgressBar(num: $stopsDone, total: stopsTotal)
        }
        .padding(20)
        .frame(height: 200)
        .overlay(
            RoundedRectangle(cornerRadius: 8.0)
                .stroke(self.user == nil ? Color.redAccent : Color.blueAccent, lineWidth: 2.0)
        )
    }
    
    private var routeProgressImage: some View {
        ZStack (alignment: .topLeading) {
            LoadingImage(url: $image)
                .roundedFrameView(width: ((UIScreen.main.bounds.width - 90) * 0.5), height: 120)
            
            Image("Route3DIcon")
                .icon(size: 60)
                .padding(.all, -17)
        }
    }
    
    private var routeProgressContent: some View {
        VStack (alignment: .leading, spacing: 8) {
            if let user = self.user {
                HStack (spacing: 4) {
                    LoadingUserImage(userImage: Binding(get: { user.imageName }, set: { _ in }), imageSize: 22)
                    
                    Text(user.name)
                        .font(.system(size: 14, weight: .bold))
                    Text("is on a")
                        .font(.system(size: 14, weight: .light))
                }
            }
            
            Text(routeName)
                .sectionCaption()
                .multilineTextAlignment(.leading)
            
            RouteProgressStat(
                collectablesDone: $collectablesDone,
                collectablesTotal: $collectablesTotal,
                stopsDone: $stopsDone,
                stopsTotal: $stopsTotal,
                align: .left
            )
        }
        .foregroundColor(Color.black)
        .frame(height: 120)
    }
}

#Preview {
    VStack (spacing: 25) {
        RouteProgressView(
            image: .constant(MockData.Attractions[0].imageURLs[0]),
            routeName: .constant("Some Route"),
            collectablesDone: .constant(2),
            collectablesTotal: .constant(5),
            stopsDone: .constant(3),
            stopsTotal: .constant(6)
        )
        RouteProgressView(
            image: .constant(MockData.Attractions[0].imageURLs[0]),
            routeName: .constant("Some Route"),
            collectablesDone: .constant(2),
            collectablesTotal: .constant(5),
            stopsDone: .constant(1),
            stopsTotal: .constant(7),
            user: .constant(MockData.Users[0])
        )
    }
    .padding()
}
