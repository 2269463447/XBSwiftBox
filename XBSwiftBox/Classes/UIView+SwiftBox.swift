//
//  UIView+SwiftBox.swift
//  XBSwiftBox_Example
//
//  Created by mac mini on 2023/11/2.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit

extension XBSwiftBox where Base: UIView {
    // MARK: - 阴影
    //添加阴影
    public func shadow(color: UIColor, alpha: CGFloat = 1, x: CGFloat = 0, y: CGFloat = 0, blur: CGFloat = 0, spread: CGFloat?) {
        let view = self.base
        view.layer.shadowColor = color.cgColor
        view.layer.shadowOpacity = Float(alpha)
        view.layer.shadowOffset = CGSize(width: x, height: y)
        view.layer.shadowRadius = blur / 2 - 1
        if let spread = spread {
            let rect = view.bounds.insetBy(dx: -spread, dy: -spread)
            view.layer.shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
    
    //更新阴影的rect，建议在layoutSubviews中调用
    public func updateShadow(spread: CGFloat) {
        let view = self.base
        let rect = view.bounds.insetBy(dx: -spread, dy: -spread)
        view.layer.shadowPath = UIBezierPath(rect: rect).cgPath
    }
}
