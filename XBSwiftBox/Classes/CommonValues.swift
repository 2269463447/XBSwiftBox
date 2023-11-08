//
//  CommonValues.swift
//  XBSwiftBox_Example
//
//  Created by mac mini on 2023/11/8.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit
import Foundation


var keyWindow: UIWindow? {
    var window: UIWindow?
    if let delegate = UIApplication.shared.delegate, let tmp = delegate.window {
        window = tmp
    }
    if window != nil {
        return window
    }
    if #available(iOS 13.0, *) {
        for scene in UIApplication.shared.connectedScenes {
            if let delegate = scene.delegate as? UIWindowSceneDelegate, let tmp = delegate.window {
                window = tmp
                break
            }
        }
    }
    if window == nil {
        window = UIApplication.shared.windows.last
    }
    if window == nil {
        window = UIApplication.shared.keyWindow
    }
    return window
}

public var statusBarHeight: CGFloat {
    var height: CGFloat = 0
    if #available(iOS 13.0, *) {
        for scene in UIApplication.shared.connectedScenes {
            if let windowScene = scene as? UIWindowScene, let statusBarManager = windowScene.statusBarManager {
                height = statusBarManager.statusBarFrame.size.height
                break
            }
        }
    }
    if height == 0 {
        height = UIApplication.shared.statusBarFrame.size.height
    }
    return height
}


public var navigationBarHeight: CGFloat {
    var topInset: CGFloat = 0
    if let window = keyWindow {
        topInset = window.safeAreaInsets.top
    }
    if topInset == 0 {
        topInset = statusBarHeight
    }
    return 44 + topInset
}

public var tabBarHeight: CGFloat {
    var height: CGFloat = 56
    if let window = keyWindow, window.safeAreaInsets.bottom > 0 {
        height = 90
    }
    return height
}


public var topViewController: UIViewController {
    func searchTop(for vc: UIViewController?) -> UIViewController? {
        if let nav = vc as? UINavigationController {
            return searchTop(for: nav.topViewController)
        }
        if let tab = vc as? UITabBarController {
            return searchTop(for: tab.selectedViewController)
        }
        return vc
    }
    
    var resultVC: UIViewController?
    guard let window = keyWindow else {
        return UIViewController()
    }
    resultVC = searchTop(for: window.rootViewController)
    while let tmp = resultVC?.presentedViewController {
        resultVC = searchTop(for: tmp)
    }
    return resultVC ?? UIViewController()
}
