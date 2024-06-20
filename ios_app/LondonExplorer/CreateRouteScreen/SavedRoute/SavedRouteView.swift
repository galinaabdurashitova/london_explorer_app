//
//  SavedRouteView.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 19.06.2024.
//

import Foundation
import SwiftUI

struct SavedRouteView: View {
    @State var route: Route
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 25) {
                    HStack {
                        ScreenHeader(
                            headline: .constant("Get ready for an adventure!"),
                            subheadline: .constant("Your route is saved")
                        )
                        Spacer()
                    }
                    
                    RouteDataView(route: $route)
                }
                .padding(.all, 20)
                
                Spacer().frame(height: 80)
            }
            
            HStack(spacing: 10) {
                ButtonView(
                    text: .constant("Create new route"),
                    colour: Color.blueAccent,
                    textColour: Color.white,
                    size: .M
                ) {
                    
                }
                
                ButtonView(
                    text: .constant("Go to my profile"),
                    colour: Color.greenAccent,
                    textColour: Color.white,
                    size: .M
                ) {
                    
                }
            }
            .padding(.bottom, 20)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.visible, for: .tabBar)
    }
}

#Preview {
    SavedRouteView(route: MockData.Routes[0])
}
