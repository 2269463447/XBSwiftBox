//
//  NSLayoutConstraint+PixelLine.swift
//  XBSwiftBox
//
//  Created by mac mini on 2024/3/21.
//

import UIKit

extension NSLayoutConstraint {
    @IBInspectable
    public var enablePixelLine: Bool {
        get {
            return constant == 1 / UIScreen.main.scale
        }
        set {
            if newValue {
                constant = 1 / UIScreen.main.scale
            }
        }
    }
}
