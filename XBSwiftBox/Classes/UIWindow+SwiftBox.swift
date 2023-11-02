//
//  UIWindow+SwiftBox.swift
//  XBSwiftBox_Example
//
//  Created by mac mini on 2023/11/2.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit

extension XBSwiftBox where Base: UIWindow {
    //设置rootViewController（带渐变动画）
    public var rootViewController: UIViewController? {
        set {
            UIView.transition(with: base, duration: 0.3, options: [.transitionCrossDissolve, .allowAnimatedContent], animations: {
                let oldState = UIView.areAnimationsEnabled
                UIView.setAnimationsEnabled(false)
                self.base.rootViewController = newValue
                UIView.setAnimationsEnabled(oldState)
            }, completion: nil)
        }
        get {
            return base.rootViewController
        }
    }
}
