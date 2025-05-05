//
//  UIImageExtensions.swift
//  Alphabetum
//
//  Created by David Gutierrez on 5/5/25.
//

import UIKit

extension UIImage {
    func resize(maxWidth: CGFloat) -> UIImage {
        let scale = maxWidth / self.size.width
        let newSize = CGSize(width: maxWidth, height: self.size.height * scale)
        
        let renderer = UIGraphicsImageRenderer(size: newSize)
        let resized = renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: newSize))
        }
        
        if let data = resized.jpegData(compressionQuality: 0.5){
            return UIImage(data: data, scale: UIScreen.main.scale) ?? resized
        }
        
        return resized
    }
}
