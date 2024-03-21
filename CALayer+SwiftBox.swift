//
//  CALayer+SwiftBox.swift
//  XBSwiftBox
//
//  Created by mac mini on 2024/3/21.
//

import UIKit

extension XBSwiftBox where Base: CALayer {
    public var image: UIImage? {
        get {
            UIGraphicsBeginImageContextWithOptions(base.bounds.size, false, UIScreen.main.scale)
            if let context = UIGraphicsGetCurrentContext() {
                base.render(in: context)
            }
            let img = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return img
        }
    }
}
