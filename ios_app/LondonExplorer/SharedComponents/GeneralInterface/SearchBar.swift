//
//  SearchBar.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 20.08.2024.
//

import Foundation
import SwiftUI

struct SearchBar: View {
    @Binding var searchText: String
    @Binding var showFilter: Bool
    @State var isFilter: Bool
    @State var searchAction: () -> Void
    
    init(searchText: Binding<String>, showFilter: Binding<Bool> = .constant(false), isFilter: Bool = false, searchAction: @escaping () -> Void) {
        self._searchText = searchText
        self._showFilter = showFilter
        self.isFilter = isFilter
        self.searchAction = searchAction
    }
    
    var body: some View {
        HStack (spacing: 15) {
            HStack (spacing: 12) {
                Image(systemName: "magnifyingglass")
                    .icon(size: 20, colour: Color.black.opacity(0.7))
                
                TextField("Search", text: $searchText)
                    .font(.system(size: 16))
                    .onChange(of: searchText) {
                        searchAction()
                    }
                
                if !searchText.isEmpty {
                    Button(action: {
                        searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .icon(size: 20, colour: Color.black.opacity(0.5))
                    }
                }
            }
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 8.0)
                    .stroke(Color.gray, lineWidth: 1.0)
            )
            
            if isFilter {
                Button(action: {
                    showFilter.toggle()
                }) {
                    Image("FilterSFIcon")
                        .icon(size: 40, colour: Color.black.opacity(0.5))
                        .padding(.all, 7)
                        .background(Color.grayBackground)
                        .cornerRadius(8)
                }
            }
        }
        .frame(height: 50)
    }
}

#Preview {
    SearchBar(searchText: .constant("")) {
        
    }
    .padding()
}
