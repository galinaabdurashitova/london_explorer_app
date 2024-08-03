//
//  EditRouteView.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 22.06.2024.
//

import Foundation
import SwiftUI

struct EditRouteView: View {
    @StateObject var viewModel: EditRouteViewModel
    
    init(route: Binding<Route>, isSheetPresented: Binding<Bool>) {
        self._viewModel = StateObject(wrappedValue: EditRouteViewModel(route: route, isSheetPresented: isSheetPresented))
    }
    
    var body: some View {
        VStack(spacing: 25) {
            HStack {
                Button("Cancel") {
                    viewModel.cancelEditRoute()
                }
                .foregroundColor(Color.redAccent)
                
                Spacer()
                
                Button("Save") {
                    viewModel.saveEditRoute()
                }
                .foregroundColor(Color.blueAccent)
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
        isSheetPresented: .constant(true)
    )
    .padding()
}
