//
//  UINavigationController+SwiftBox.swift
//  XBSwiftBox
//
//  Created by mac mini on 2024/3/21.
//

import UIKit

extension XBSwiftBox where Base: UINavigationController {
    public func pushWithTopRemoved(_ viewController: UIViewController) {
        if base.tabBarController?.tabBar.isHidden == true {
            viewController.hidesBottomBarWhenPushed = true
        }
        var stack = base.viewControllers
        let _ = stack.popLast()
        stack.append(viewController)
        
        base.setViewControllers(stack, animated: true)
    }
    
    public func push(_ viewController: UIViewController, topperRemoved type: UIViewController.Type, forward: Bool = true) {
        if base.tabBarController?.tabBar.isHidden == true {
            viewController.hidesBottomBarWhenPushed = true
        }
        let stack = base.viewControllers
        var newStack = [UIViewController]()
        if forward {
            //正向遍历
            for vc in stack {
                if vc.isKind(of: type) {
                    break
                }
                newStack.append(vc)
            }
        } else {
            //反向遍历
            var index = -1
            for i in (0 ..< stack.count).reversed() {
                if stack[i].isKind(of: type) {
                    index = i
                    break
                }
            }
            if index > 0 {
                newStack = Array(stack[0 ..< index])
            }
        }
        newStack.append(viewController)
        
        base.setViewControllers(newStack, animated: true)
    }
}
