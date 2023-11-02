//
//  UIView+Touchable.swift
//  XBSwiftBox_Example
//
//  Created by mac mini on 2023/11/2.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit

private var ViewTouchableStoreKey = "ViewTouchableStoreKey"

fileprivate struct WeakTargetActionSet {
    weak var target: AnyObject?
    var action: Selector?
}

fileprivate struct ViewTouchableStore {
    var flag: Bool?
    var normalColor: UIColor?
    var touchColor: UIColor? = UIColor(0xDADADA, 1)
    var actionMap = [WeakTargetActionSet]()
}

extension XBSwiftBox where Base: UIView {
    
    private var touchableStore: ViewTouchableStore? {
        get {
            if let store = objc_getAssociatedObject(self.base, &ViewTouchableStoreKey) as? ViewTouchableStore {
                return store
            }
            return nil
        }
        set {
            objc_setAssociatedObject(self.base, &ViewTouchableStoreKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    fileprivate var originalColor: UIColor? {
        get {
            return touchableStore?.normalColor
        }
        set {
            var store = ViewTouchableStore()
            if let tmp = touchableStore {
                store = tmp
            }
            store.normalColor = newValue
            touchableStore = store
        }
    }
    
    fileprivate var targetActions: [WeakTargetActionSet]? {
        get {
            return touchableStore?.actionMap
        }
    }
    
    public var showsTouchWhenHighlighted: Bool {
        get {
            return touchableStore?.flag ?? false
        }
        set {
            var store = ViewTouchableStore()
            if let tmp = touchableStore {
                store = tmp
            }
            store.flag = newValue
            touchableStore = store
        }
    }
    
    public var highlightedColor: UIColor? {
        get {
            return touchableStore?.touchColor
        }
        set {
            var store = ViewTouchableStore()
            if let tmp = touchableStore {
                store = tmp
            }
            store.touchColor = newValue
            touchableStore = store
        }
    }
    
    public func addTarget(_ target: AnyObject, action: Selector) {
        var store = ViewTouchableStore()
        if let tmp = touchableStore {
            store = tmp
        }
        store.actionMap.append(WeakTargetActionSet(target: target, action: action))
        touchableStore = store
    }
}

extension UIView {
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        if !xb.showsTouchWhenHighlighted {
            return
        }
        xb.originalColor = backgroundColor
        backgroundColor = xb.highlightedColor
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        restoreEffect()
        //点击响应事件
        xb.targetActions?.forEach({ set in
            _ = set.target?.perform(set.action, with: self)
        })
    }
    
    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        
        restoreEffect()
    }
    
    private func restoreEffect() {
        if !xb.showsTouchWhenHighlighted {
            return
        }
        backgroundColor = xb.originalColor
    }
}
