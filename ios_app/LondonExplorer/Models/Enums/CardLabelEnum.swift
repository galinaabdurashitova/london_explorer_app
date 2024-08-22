//
//  Label.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 31.05.2024.
//

import Foundation
import SwiftUI

enum CardLabel {
    case likes(Int)
    case download(Date)
    case empty
    case completed(Date)

    @ViewBuilder
    var view: some View {
        switch self {
        case .likes(let likes):
            HStack(spacing: 3) {
                Text(String(likes))
                    .font(.system(size: 14, weight: .bold))
                Image(systemName: "heart.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 15)
            }
            .foregroundColor(Color.redDark)
        case .download(let date):
            HStack(spacing: 3) {
                Text("Saved on")
                    .font(.system(size: 12))
                Text(formattedDate(date: date))
                    .font(.system(size: 12, weight: .bold))
            }
        case .empty:
            EmptyView()
        case .completed(let date):
            HStack(spacing: 3) {
                Text("Completed on")
                    .font(.system(size: 12))
                Text(formattedDate(date: date))
                    .font(.system(size: 12, weight: .bold))
            }
        }
    }

    private func formattedDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: date)
    }
}
