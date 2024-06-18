//
//  CreateRouteCard.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 08.06.2024.
//

import Foundation
import SwiftUI

struct CreateRouteCard: View {
    @EnvironmentObject var networkMonitor: NetworkMonitor
    
    var body: some View {
        if networkMonitor.isConnected {
            NavigationLink(destination: RouteStopsView()) {
                CreateNewRouteCard
            }
        } else {
            NoInternetCard
        }
    }
    
    private var CreateNewRouteCard: some View {
        VStack {
            ZStack {
                Circle()
                    .foregroundColor(Color.white.opacity(0.7))
                
                ZStack (alignment: .bottomTrailing) {
                    Image("MapMarker3DIcon")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 130)
                    
                    Image("Plus3DIcon")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 50)
                }
                .padding(.bottom, -10)
            }
            .frame(width: 194, height: 194)
            .padding(.top, -35)
            
            Text("Create New Route")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(Color.black)
                .kerning(-0.2)
                .padding(.vertical)
        }
        .frame(width: 156, height: 221)
        .background(Color.redAccent.opacity(0.3))
        .cornerRadius(8)
    }
    
    private var NoInternetCard: some View {
        VStack (alignment: .center, spacing: 12) {
            Image(systemName: "wifi.slash")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50)
                .padding()
                .background(Color.white)
                .cornerRadius(100)
                .foregroundColor(Color.black)
                .fontWeight(.light)
            
            Text("Oops!")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(Color.black.opacity(0.5))
            
            Text("To create a new route you need an internet connection")
                .font(.system(size: 13))
                .foregroundColor(Color.black.opacity(0.5))
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(width: 156, height: 221)
        .background(Color.grayBackground)
        .cornerRadius(8)
    }
}

#Preview {
    CreateRouteCard()
        .environmentObject(NetworkMonitor())
}
