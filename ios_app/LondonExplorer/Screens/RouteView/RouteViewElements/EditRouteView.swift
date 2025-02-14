//
//  EditRouteView.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 22.06.2024.
//

import Foundation
import SwiftUI

struct EditRouteView: View {
    @EnvironmentObject var globalSettings: GlobalSettings
    @ObservedObject var viewModel: RouteViewModel
    
    var body: some View {
        VStack(spacing: 25) {
            topButtons
            
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    ScreenHeader(
                        headline: .constant("Edit route"),
                        subheadline: .constant("Edit route's name and description")
                    )
                }
                Spacer()
            }
            
            if let error = viewModel.editError {
                Text(error)
                    .foregroundColor(Color.redAccent)
            }
            
            textFields
            
            Spacer()
        }
        .padding()
    }
    
    private var topButtons: some View {
        HStack {
            Button("Cancel") {
                viewModel.cancelEditRoute()
            }
            .foregroundColor(Color.redAccent)
            
            Spacer()
            
            Button("Save") {
                viewModel.saveEditRoute()
                globalSettings.setProfileReloadTrigger(to: true)
            }
            .foregroundColor(Color.blueAccent)
            .disabled(viewModel.newName.isEmpty || viewModel.newDescription.isEmpty)
        }
    }
    
    private var textFields: some View {
        VStack(alignment: .leading, spacing: 10) {
            CustomTextField(fieldText: .constant("Route Name"), fillerText: .constant("Type route name here..."), textVariable: $viewModel.newName, maxLength: 64)
            
            CustomTextField(fieldText: .constant("Route Description"), fillerText: .constant("Fill in route description..."), textVariable: $viewModel.newDescription, height: 200, maxLength: 32000)
        }
    }
}

#Preview {
    EditRouteView(viewModel: RouteViewModel(route: MockData.Routes[0]))
        .environmentObject(GlobalSettings())
        .padding()
}
