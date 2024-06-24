//
//  EditRouteView.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 22.06.2024.
//

import Foundation
import SwiftUI

struct EditRouteView: View {
    @ObservedObject var viewModel: EditRouteViewModel
    var button: AnyView
    
    init(route: Binding<Route>, button: AnyView) {
        self.viewModel = EditRouteViewModel(route: route)
        self.button = button
    }
    
    var body: some View {
        Button(action: {
            viewModel.isSheetPresented = true
        }) {
            button
        }
        .sheet(isPresented: $viewModel.isSheetPresented) {
            editSheet
        }
    }
    
    var editSheet: some View {
        VStack(spacing: 25) {
            HStack {
                Button("Save") {
                    viewModel.saveEditRoute()
                }
                .foregroundColor(Color.blueAccent)
                
                Spacer()
                
                Button("Cancel") {
                    viewModel.cancelEditRoute()
                }
                .foregroundColor(Color.redAccent)
            }
            
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    ScreenHeader(
                        headline: .constant("Edit route"),
                        subheadline: .constant("Edit route's name and description")
                    )
                }
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 10) {
                CustomTextField(fieldText: .constant("Route Name"), fillerText: .constant("Type route name here..."), textVariable: $viewModel.name, maxLength: 64)
                
                CustomTextField(fieldText: .constant("Route Description"), fillerText: .constant("Fill in route description..."), textVariable: $viewModel.description, height: 200, maxLength: 32000)
            }
            
            Spacer()
        }
        .padding(.all, 20)
    }
}

#Preview {
    EditRouteView(
        route: .constant(MockData.Routes[0]),
        button: AnyView(Image(systemName: "circle"))
    )
    .padding()
}
