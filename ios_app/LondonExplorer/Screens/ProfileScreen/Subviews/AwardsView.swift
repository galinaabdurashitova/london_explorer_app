//
//  AwardsView.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 16.08.2024.
//

import Foundation
import SwiftUI

struct AwardsView: View {
    @EnvironmentObject var auth: AuthController
    @State var user: User
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .center, spacing: 25) {
                HStack {
                    let awardCount = "\(String(user.awards.count))/\(String(AwardTypes.allCases.count * 3))"
                    let username = user.id == auth.profile.id
                    
                    ScreenHeader(
                        headline: .constant("\(username ? "Your" : "\(user.name)'s") awards"),
                        subheadline:  .constant("\(username ? "You" : user.name) recieved \(awardCount) awards")
                    )
                    
                    Spacer()
                }
                
                VStack(alignment: .leading, spacing: 15) {
                    ForEach(AwardTypes.allCases.indices, id: \.self) { awardIndex in
                        awardCard(award: AwardTypes.allCases[awardIndex], index: awardIndex)
                    }
                }
            }
        }
        .padding(.horizontal)
    }
    
    private func awardCard(award: AwardTypes, index: Int) -> some View {
        HStack(spacing: 4) {
            if let level = AwardLevel(rawValue: award.getUserLevel(user: user)) {
                level.getImage(award: award, colour: getColour(index: index))
            } else {
                Image("Start3DIcon")
            }
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 7) {
                VStack(alignment: .leading, spacing: 0) {
                    if let userAward = award.getCurrentLevel(user: user) {
                        Text("You recieved a \(AwardLevel(rawValue: userAward.level)?.awardName ??  "star") for")
                            .subheadline(.center)
                        
                        Text(award.rawValue)
                            .sectionCaption()
                        
                        Text("recieved on \(DateConverter(format: "dd/MM/yy").toString(from: userAward.date))")
                            .headline()
                    } else {
                        Text("You can recieve an award for")
                            .subheadline(.center)

                        Text(award.rawValue)
                            .sectionCaption()
                    }
                }
                    
                awardProgressBar(award: award, colour: getColour(index: index))
                    .frame(maxWidth: .infinity)
            }
        }
        .padding(.vertical, 15)
        .padding(.horizontal, 12)
        .overlay(
            RoundedRectangle(cornerRadius: 10.0)
                .stroke(
                    getColour(index: index),
                    lineWidth: 4.0
                )
        )
        .cornerRadius(10)
    }
    
    private func awardProgressBar(award: AwardTypes, colour: Color) -> some View {
        VStack(alignment: .center, spacing: 2) {
            let currentPoints = award.getPoints(user: user)
            let currentLevel = award.getLevelPoints(level: award.getUserLevel(user: user))
            let nextLevel = award.getLevelPoints(level: award.getUserLevel(user: user) + 1)
            
            HStack {
                Text(String(format: "%.0f", currentLevel))
                
                Spacer()
                
                if currentLevel != nextLevel {
                    Text(String(format: "%.0f", nextLevel))
                }
            }
            .font(.system(size: 14, weight: .light))
            .foregroundColor(Color.black.opacity(0.5))
            
            ProgressBar(
                num: Binding(
                    get: { currentPoints - currentLevel },
                    set: { _ in }
                ),
                total: Binding(
                    get: { nextLevel - currentLevel },
                    set: { _ in }
                ),
                colour: .constant(colour)
            )
            
            HStack(spacing: 4) {
                if let level = AwardLevel(rawValue: award.getUserLevel(user: user) + 1) {
                    Text("\(String(format: "%.0f", currentPoints))/\(String(format: "%.0f", nextLevel))")
                        .font(.system(size: 12, weight: .semibold))
                    Text("to get a \(level.awardName)")
                        .font(.system(size: 12, weight: .light))
                } else {
                    Text(String(format: "%.0f", currentPoints))
                        .font(.system(size: 12, weight: .semibold))
                    Text("in total")
                        .font(.system(size: 12, weight: .light))
                }
            }
            .foregroundColor(Color.black.opacity(0.5))
        }
    }
    
    private func getColour(index: Int) -> Color {
        return index % 4 == 1 ? Color.yellowAccent
                : index % 4 == 2 ? Color.blueAccent
                : index % 4 == 3 ? Color.greenAccent
                : Color.redAccent
    }
}

#Preview {
    AwardsView(user: MockData.Users[0])
        .environmentObject(AuthController(testProfile: true))
}
