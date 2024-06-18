//
//  ImageCodableExtension.swift
//  LondonExplorer
//
//  Created by Galina Abdurashitova on 18.06.2024.
//

import Foundation
import SwiftUI

extension UIImage {
    func encode() -> Data? {
        return self.jpegData(compressionQuality: 1)
    }

    static func decode(data: Data) -> UIImage? {
        return UIImage(data: data)
    }
}

extension Image {
    func asUIImage() -> UIImage? {
        let controller = UIHostingController(rootView: self.resizable())
        guard let view = controller.view else { return nil }

        let targetSize = CGSize(width: 1, height: 1)  // Adjust to needed size
        view.bounds = CGRect(origin: .zero, size: targetSize)
        view.backgroundColor = .clear

        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { _ in
            view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        }
    }
}
