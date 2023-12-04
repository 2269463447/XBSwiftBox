//
//  UIImage+SwiftBox.swift
//  XBSwiftBox_Example
//
//  Created by mac mini on 2023/12/4.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit

extension XBSwiftBox where Base: UIImage {
    // MARK: - 图片压缩
    public func resizableImageData(withMinWidth min: CGFloat = 0, maxWidth max: CGFloat, maxDataSize size: Int) -> Data? {
        let maxDataSize: CGFloat = CGFloat(size)
        var maxImageSize: CGFloat = 1024
        if max > 0 {
            maxImageSize = max
        }
        
        let image = base
        // 调整分辨率
        var newSize = CGSize(width: image.size.width, height: image.size.height)
        
        let tempHeight = newSize.height / maxImageSize
        let tempWidth = newSize.width / maxImageSize
        
        if tempWidth > 1.0 && tempWidth > tempHeight {
            newSize = CGSize(width: image.size.width / tempWidth, height: image.size.height / tempWidth)
        } else if tempHeight > 1.0 && tempWidth < tempHeight {
            newSize = CGSize(width: image.size.width / tempHeight, height: image.size.height / tempHeight)
        }
        
        UIGraphicsBeginImageContext(newSize)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let newImage = newImage else { return nil }
        guard var imageData = newImage.jpegData(compressionQuality: 1.0) else { return nil }
        // 调整大小
        var sizeOriginKB: CGFloat = CGFloat(imageData.count) / 1024
        var resizeRate: CGFloat = 0.9
        while sizeOriginKB > maxDataSize && resizeRate > 0.1 {
            if let tmp = newImage.jpegData(compressionQuality: resizeRate) {
                imageData = tmp
            }
            sizeOriginKB = CGFloat(imageData.count) / 1024
            resizeRate -= 0.1
        }
        
        return imageData
    }
    
    public func resizeData() -> Data? {
        return resizableImageData(withMinWidth: 1, maxWidth: 4096, maxDataSize: 10 * 1024 * 1024)
    }
    
    // MARK: - 生成NSMutableAttributedString
    public func attributedString(_ bounds: CGRect) -> NSMutableAttributedString {
        let attach = NSTextAttachment()
        attach.image = base
        attach.bounds = bounds
        
        return NSMutableAttributedString(attributedString: NSAttributedString(attachment: attach))
    }
    
    // 添加圆角
    public func addRoundCorner(cornerRadius: CGFloat, by roundingCorners: UIRectCorner = .allCorners) -> UIImage {
        var resultImage = base
        let imageView = UIImageView(image: base)
        imageView.frame = CGRect(origin: .zero, size: base.size)
        
        // 创建一个贝塞尔路径
        let bezierPath = UIBezierPath(roundedRect: imageView.bounds, byRoundingCorners: roundingCorners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        
        // 创建一个遮罩层
        let maskLayer = CAShapeLayer()
        maskLayer.path = bezierPath.cgPath
        
        // 将遮罩层应用于图像视图的图层
        imageView.layer.mask = maskLayer
        
        // 将图像视图绘制到图形上下文中
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, UIScreen.main.scale)
        if let context = UIGraphicsGetCurrentContext() {
            imageView.layer.render(in: context)
            if let roundedImage = UIGraphicsGetImageFromCurrentImageContext() as? Base {
                resultImage = roundedImage
            }
            UIGraphicsEndImageContext()
        }
        return resultImage
    }
    
}
