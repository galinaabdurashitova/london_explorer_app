//
//  ProfileCollectablesView.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 13.08.2024.
//

import Foundation
import SwiftUI

struct ProfileCollectablesView: View {
    @EnvironmentObject var auth: AuthController
    @State var user: User
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .center, spacing: 25) {
                HStack {
                    ScreenHeader(
                        headline: user.id == auth.profile.id ? .constant("Your collectables") : .constant("\(user.name)'s collectables"),
                        subheadline: user.id == auth.profile.id ? .constant("You found \(String(user.collectables.count))/20 collectables") : .constant("\(user.name) found \(String(user.collectables.count))/20 collectables")
                    )
                    
                    Spacer()
                }
                
                VStack(alignment: .leading, spacing: 15) {
                    ForEach(0..<(Collectable.allCases.count + 1) / 2) { rowIndex in
                        HStack(spacing: 15) {
                            let rowSlice = Array(
                                Collectable.allCases[
                                    (rowIndex * 2)..<min(
                                        rowIndex * 2 + 2,
                                        Collectable.allCases.count
                                    )
                                ]
                            )
                            
                            ForEach(rowSlice.indices, id: \.self) { collectableIndex in
                                let index = rowIndex * 2 + collectableIndex
                                
                                if let userCollectable = user.collectables.first(where: { $0.type == Collectable.allCases[index] }) {
                                    collectableCard(collectable: userCollectable, index: index)
                                } else {
                                    unknownCollectableCard
                                }
                                
                            }
                        }
                    }
                }
            }
        }
        .padding(.horizontal)
    }
    
    private var unknownCollectableCard: some View {
        VStack(spacing: 5) {
            ZStack {
                Circle()
                    .foregroundColor(Color.white)
                    .frame(width: 110)
                    .blur(radius: 15)
                
                Text("?")
                    .font(.system(size: 26, weight: .medium))
                    .opacity(0.8)
            }
            .padding(.bottom, 15)
            
            Text("Unknown Collectable")
                .headline()
            
            Text("Follow more routes to find it")
                .subheadline(.center)
        }
        .frame(width: (UIScreen.main.bounds.width - 55) / 2, height: 220)
        .background(Color.black.opacity(0.2))
        .cornerRadius(8)
    }
    
    private func collectableCard(collectable: User.UserCollectable, index: Int) -> some View {
        VStack(spacing: 5) {
            collectable.type.image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 140)
                .cornerRadius(100)
            
            Text(collectable.type.rawValue)
                .headline()
            
            if let finishedRoute = user.finishedRoutes.first(where: { $0.id == collectable.finishedRouteId }) {
                VStack(spacing: 0) {
                    Text("found on \(DateConverter(format: "dd/MM/yy").toString(from: finishedRoute.finishedDate))")
                        .subheadline(.center)
                    if let route = finishedRoute.route {
                        Text(route.name)
                            .subheadline(.center)
                    }
                }
            }
        }
        .frame(width: (UIScreen.main.bounds.width - 55) / 2, height: 220)
        .background(
            index % 4 == 1 ? Color.redAccent.opacity(0.2)
            : index % 4 == 2 ? Color.blueAccent.opacity(0.2)
            : index % 4 == 3 ? Color.yellowAccent.opacity(0.2)
            : Color.greenAccent.opacity(0.2))
        .cornerRadius(8)
    }
}

#Preview {
    ProfileCollectablesView(user: MockData.Users[0])
        .environmentObject(AuthController(testProfile: true))
}
