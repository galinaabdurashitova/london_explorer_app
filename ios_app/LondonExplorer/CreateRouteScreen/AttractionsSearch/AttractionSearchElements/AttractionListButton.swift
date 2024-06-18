//
//  AttractionListButton.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 10.06.2024.
//

import Foundation
import SwiftUI

struct AttractionListButton: View {
    @ObservedObject var viewModel: AttractionSearchViewModel
    @Binding var attraction: Attraction
    
    var body: some View {
        if let id = viewModel.stops.first(where: { $0.attraction == $attraction.wrappedValue })?.stepNo {
            Text(String(id))
                .frame(width: 35, height: 35)
                .background(Color.redAccent)
                .cornerRadius(100)
                .foregroundColor(Color.white)
                .font(.system(size: 18, weight: .bold))
        } else {
            Image(systemName: "circle")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .fontWeight(.ultraLight)
                .frame(width: 35)
                .foregroundColor(Color.black.opacity(0.5))
        }
    }
}

#Preview {
    AttractionListButton(
        viewModel: AttractionSearchViewModel(),
        attraction: .constant(MockData.Attractions[0])
    )
}
