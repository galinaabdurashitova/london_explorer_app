//
//  AwardLevel.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 16.08.2024.
//

import Foundation
import SwiftUI

enum AwardLevel: Int {
    case zero = 0
    case first = 1
    case second = 2
    case third = 3
    
    var imageName: String {
        switch self {
        case .zero:     return ""
        case .first:    return "Start3DIcon"
        case .second:   return  "Medal3DIcon"
        case .third:    return  "Trophy3DIcon"
        }
    }
    
    var awardName: String {
        switch self {
        case .zero:     return ""
        case .first:    return "star"
        case .second:   return  "medal"
        case .third:    return  "trophy"
        }
    }
    
    var cardPadding: Double {
        switch self {
        case .zero:     return 0
        case .first:    return -5
        case .second:   return 17
        case .third:    return 12
        }
    }
    
    @ViewBuilder
    func getImage(award: AwardTypes, colour: Color = Color.clear, sizeMultiply: Double = 1) -> some View {
        ZStack {
            Circle()
                .fill(colour)
                .frame(width: 100 * sizeMultiply)
                .opacity(0.2)
            
            if self == .zero {
                award.image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80 * sizeMultiply)
            } else {
                Image(self.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80 * sizeMultiply)
            }
            
            if self.rawValue > 0 {
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.7))
                        .blur(radius: 5)
                    
                    award.image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
                .frame(width: 40 * sizeMultiply)
                .padding(.bottom, self.cardPadding)
            }
        }
    }
}
