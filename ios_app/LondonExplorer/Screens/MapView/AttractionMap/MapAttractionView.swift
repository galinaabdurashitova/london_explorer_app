//
//  MapAttractionView.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 09.06.2024.
//

import Foundation
import SwiftUI
import MapKit

struct MapAttractionView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var attraction: Attraction
    @State var showSheet: Bool = true
    
    var body: some View {
        ZStack (alignment: .topLeading) {
            Map(
                initialPosition:
                    MapCameraPosition.region(
                        MKCoordinateRegion(
                            center: attraction.coordinates,
                            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                        )
                    )
            ) {
                Annotation(attraction.name, coordinate: attraction.coordinates) {
                    AttractionAnnotation
                }
                .annotationTitles(.hidden)
            }
            .onTapGesture {
                showSheet = true
            }
                        
            BackButton() {
                self.presentationMode.wrappedValue.dismiss()
            }
            .padding(.leading)
        }
        .navigationBarBackButtonHidden(true)
        .sheet(isPresented: $showSheet) {
            AttractionSheetContent(attraction: $attraction)
                .padding(.horizontal)
                .padding(.top, 20)
                .edgesIgnoringSafeArea(.bottom) 
                .gesture(DragGesture().onChanged { _ in })
                .presentationCornerRadius(30)
                .presentationDetents([.height(200), .height(90)])
                .presentationBackgroundInteraction(.enabled)
                .interactiveDismissDisabled()
        }
    }
    
    private var AttractionAnnotation: some View {
        ZStack {
            Circle()
                .frame(width: 105, height: 105)
                .foregroundColor(Color.redAccent)
            
            Rectangle()
                .frame(width: 50, height: 50)
                .rotationEffect(.degrees(45))
                .foregroundColor(Color.redAccent)
                .padding(.top, 80)
            
            Image(uiImage: attraction.images[0])
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 100)
                .cornerRadius(100)
        }
        .shadow(radius: 5)
        .padding(.top, -140)
    }
}

#Preview {
    MapAttractionView(
        attraction: .constant(MockData.Attractions[0])
    )
}
