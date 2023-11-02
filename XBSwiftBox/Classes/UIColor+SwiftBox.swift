//
//  UIColor+SwiftBox.swift
//  XBSwiftBox_Example
//
//  Created by mac mini on 2023/11/2.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit

extension XBSwiftBox where Base: UIColor {
    // MARK: - 图片
    //生成图片
    public func image(size: CGSize = CGSize(width: 1, height: 1), cornerRadius: CGFloat? = nil) -> UIImage? {
        let scale = UIScreen.main.scale
        
        let imageSize = CGSize(width: size.width * scale, height: size.height * scale)
        UIGraphicsBeginImageContext(imageSize)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(base.cgColor)
        context?.fill(CGRect(origin: .zero, size: imageSize))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if let radius = cornerRadius, let img = image {
            let imageRect = CGRect(origin: .zero, size: size)
            UIGraphicsBeginImageContextWithOptions(size, false, scale)
            let context = UIGraphicsGetCurrentContext()
            context?.setShouldAntialias(true)
            let bezierPath = UIBezierPath(roundedRect: imageRect, cornerRadius: radius)
            bezierPath.close()
            bezierPath.addClip()
            img.draw(in: imageRect)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return image
        }
        
        return image
    }
}
