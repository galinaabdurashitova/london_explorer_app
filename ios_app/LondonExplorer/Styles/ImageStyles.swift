//
//  ImageStyles.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 31.05.2024.
//

import Foundation
import SwiftUI

extension View {
    func roundedFrameView(width: Double = 100, height: Double = 100) -> some View {
        self
            .frame(width: width, height: height)
            .cornerRadius(8)
    }
    
    func profilePictureView(size: Double = 100) -> some View {
        self
            .frame(width: size, height: size)
            .cornerRadius(100)
    }
}

extension Image {

    func profilePicture(size: Double = 100) -> some View {
        self
            .resizable()
            .aspectRatio(contentMode: .fill)
            .profilePictureView(size: size)
    }
    
    func icon(size: Double = 100, colour: Color? = nil) -> some View {
        let imageContent = self.resizable().aspectRatio(contentMode: .fit)
        
        return Group {
            if let colour = colour {
                colour
                    .frame(width: size, height: size)
                    .mask(imageContent)
            } else {
                imageContent
                    .frame(width: size, height: size)
            }
        }
    }
    
    func roundedFrame(width: Double = 100, height: Double = 100) -> some View {
        self
            .resizable()
            .aspectRatio(contentMode: .fill)
            .roundedFrameView(width: width, height: height)
    }
    
    func roundedHeightFrame(height: Double = 100) -> some View {
        self
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(height: height)
            .cornerRadius(8)
    }
    
    func roundedWidthFrame(width: Double = 100) -> some View {
        self
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: width)
            .cornerRadius(8)
    }
}

#Preview {
    VStack(spacing: 25) {
        Image("Anna")
            .profilePicture()
        
        Image("WalkiOSIcon")
            .icon()
        
        Image("Anna")
            .roundedFrame(width: 100, height: 100)
    
        Image("Anna")
            .roundedHeightFrame()
        
        Image("Anna")
            .roundedWidthFrame()
    }
    .padding()
}
