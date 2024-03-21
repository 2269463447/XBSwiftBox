//
//  FreeLayout.swift
//  XBSwiftBox
//
//  Created by mac mini on 2024/3/21.
//

import UIKit

// MARK: - UIView
public struct FreeLayoutAttribute {
    let view: UIView
    let attribute: NSLayoutConstraint.Attribute
    let constant: CGFloat?
    let multiplier: CGFloat?
    
    init(view: UIView, attribute: NSLayoutConstraint.Attribute) {
        self.view = view
        self.attribute = attribute
        self.constant = nil
        self.multiplier = nil
        view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    init(view: UIView, attribute: NSLayoutConstraint.Attribute, constant: CGFloat?, multiplier: CGFloat?) {
        self.view = view
        self.attribute = attribute
        self.constant = constant
        self.multiplier = multiplier
        view.translatesAutoresizingMaskIntoConstraints = false
    }
}

extension QSwiftBox where Base: UIView {
    
    public var width: FreeLayoutAttribute {
        return FreeLayoutAttribute(view: self.base, attribute: .width)
    }
    
    public var height: FreeLayoutAttribute {
        return FreeLayoutAttribute(view: self.base, attribute: .height)
    }
    
    public var top: FreeLayoutAttribute {
        return FreeLayoutAttribute(view: self.base, attribute: .top)
    }
    
    public var bottom: FreeLayoutAttribute {
        return FreeLayoutAttribute(view: self.base, attribute: .bottom)
    }
    
    public var left: FreeLayoutAttribute {
        return FreeLayoutAttribute(view: self.base, attribute: .left)
    }
    
    public var right: FreeLayoutAttribute {
        return FreeLayoutAttribute(view: self.base, attribute: .right)
    }
    
    public var leading: FreeLayoutAttribute {
        return FreeLayoutAttribute(view: self.base, attribute: .leading)
    }
    
    public var trailing: FreeLayoutAttribute {
        return FreeLayoutAttribute(view: self.base, attribute: .trailing)
    }
    
    public var centerX: FreeLayoutAttribute {
        return FreeLayoutAttribute(view: self.base, attribute: .centerX)
    }
    
    public var centerY: FreeLayoutAttribute {
        return FreeLayoutAttribute(view: self.base, attribute: .centerY)
    }
    
    public var firstBaseline: FreeLayoutAttribute {
        return FreeLayoutAttribute(view: self.base, attribute: .firstBaseline)
    }
    
    public var lastBaseline: FreeLayoutAttribute {
        return FreeLayoutAttribute(view: self.base, attribute: .lastBaseline)
    }
    
    public var edges: FreeLayoutAttribute {
        return FreeLayoutAttribute(view: self.base, attribute: .notAnAttribute)
    }
    
    @discardableResult
    public func constraint(item view1: AnyObject,
                           attribute attr1: NSLayoutConstraint.Attribute,
                           relatedBy: NSLayoutConstraint.Relation = .equal,
                           toItem view2: AnyObject? = nil,
                           attribute attr2: NSLayoutConstraint.Attribute? = nil,
                           multiplier: CGFloat = 1,
                           constant: CGFloat = 0) -> NSLayoutConstraint {
        let c = NSLayoutConstraint(
            item: view1,
            attribute: attr1,
            relatedBy: relatedBy,
            toItem: view2,
            attribute: ((attr2 == nil) ? attr1 : attr2! ),
            multiplier: multiplier,
            constant: constant
        )
        c.priority = UILayoutPriority(rawValue: UILayoutPriority.defaultHigh.rawValue + 1)
        base.addConstraint(c)
        return c
    }
}

@discardableResult
public func == (left: FreeLayoutAttribute, right: FreeLayoutAttribute) -> NSLayoutConstraint {
    let constant = right.constant ?? left.constant ?? 0
    let multiplier = right.multiplier ?? left.multiplier ?? 1
    
    if left.view.superview == right.view.superview { // A and B are at the same level
        // Old code
        if let spv = left.view.superview {
            return spv.qs.constraint(item: left.view,
                                     attribute: left.attribute,
                                     toItem: right.view,
                                     attribute: right.attribute,
                                     multiplier: multiplier,
                                     constant: constant)
        }
    } else if left.view.superview == right.view { // A is in B (first level)
        return right.view.qs.constraint(item: left.view,
                                        attribute: left.attribute,
                                        toItem: right.view,
                                        attribute: right.attribute,
                                        multiplier: multiplier,
                                        constant: constant)
    } else if right.view.superview == left.view { // B is in A (first level)
        return left.view.qs.constraint(item: right.view,
                                       attribute: right.attribute,
                                       toItem: left.view,
                                       attribute: left.attribute,
                                       multiplier: multiplier,
                                       constant: constant)
    } else if left.view.isDescendant(of: right.view) { // A is in B (LOW level)
        return right.view.qs.constraint(item: left.view,
                                        attribute: left.attribute,
                                        toItem: right.view,
                                        attribute: right.attribute,
                                        multiplier: multiplier,
                                        constant: constant)
    } else if right.view.isDescendant(of: left.view) { // B is in A (LOW level)
        return left.view.qs.constraint(item: left.view,
                                       attribute: left.attribute,
                                       toItem: right.view,
                                       attribute: right.attribute,
                                       multiplier: multiplier,
                                       constant: constant)
    } else {
        let commonSuperview: (UIView, UIView) -> UIView? = { viewA, viewB in
            // Both views should have a superview
            guard viewA.superview != nil && viewB.superview != nil else {
                return nil
            }
            
            // Find the common parent
            var spv = viewA.superview
            while spv != nil {
                if viewA.isDescendant(of: spv!) && viewB.isDescendant(of: spv!) {
                    return spv
                } else {
                    spv = spv?.superview
                }
            }
            return nil
        }
        if let superview = commonSuperview(left.view, right.view) { // Look for common ancestor
            return superview.qs.constraint(item: left.view,
                                           attribute: left.attribute,
                                           toItem: right.view,
                                           attribute: right.attribute,
                                           multiplier: multiplier,
                                           constant: constant)
        }
    }
    
    return NSLayoutConstraint()
}

@discardableResult
public func >= (left: FreeLayoutAttribute, right: FreeLayoutAttribute) -> NSLayoutConstraint {
    let constant = right.constant ?? 0
    let multiplier = right.multiplier ?? 1
    if let spv = left.view.superview {
        return spv.qs.constraint(item: left.view,
                                 attribute: left.attribute,
                                 relatedBy: .greaterThanOrEqual,
                                 toItem: right.view,
                                 attribute: right.attribute,
                                 multiplier: multiplier,
                                 constant: constant)
    }
    return NSLayoutConstraint()
}

@discardableResult
public func <= (left: FreeLayoutAttribute, right: FreeLayoutAttribute) -> NSLayoutConstraint {
    let constant = right.constant ?? 0
    let multiplier = right.multiplier ?? 1
    if let spv = left.view.superview {
        return spv.qs.constraint(item: left.view,
                                 attribute: left.attribute,
                                 relatedBy: .lessThanOrEqual,
                                 toItem: right.view,
                                 attribute: right.attribute,
                                 multiplier: multiplier,
                                 constant: constant)
    }
    return NSLayoutConstraint()
}

@discardableResult
public func + (left: FreeLayoutAttribute, right: CGFloat) -> FreeLayoutAttribute {
    return FreeLayoutAttribute(view: left.view, attribute: left.attribute, constant: right, multiplier: left.multiplier)
}

@discardableResult
public func - (left: FreeLayoutAttribute, right: CGFloat) -> FreeLayoutAttribute {
    return FreeLayoutAttribute(view: left.view, attribute: left.attribute, constant: -right, multiplier: left.multiplier)
}

@discardableResult
public func * (left: FreeLayoutAttribute, right: CGFloat) -> FreeLayoutAttribute {
    return FreeLayoutAttribute(view: left.view, attribute: left.attribute, constant: left.constant, multiplier: right)
}

@discardableResult
public func / (left: FreeLayoutAttribute, right: CGFloat) -> FreeLayoutAttribute {
    return left * (1/right)
}

@discardableResult
public func % (left: CGFloat, right: FreeLayoutAttribute) -> FreeLayoutAttribute {
    return right * (left/100)
}

@discardableResult
public func == (left: FreeLayoutAttribute, right: CGFloat) -> NSLayoutConstraint {
    if let spv = left.view.superview {
        var toItem: UIView? = spv
        var constant: CGFloat = right
        if left.attribute == .width || left.attribute == .height {
            toItem = nil
        }
        if left.attribute == .bottom || left.attribute == .right {
            constant = -constant
        }
        return spv.qs.constraint(item: left.view,
                                 attribute: left.attribute,
                                 toItem: toItem,
                                 constant: constant)
    }
    return NSLayoutConstraint()
}

@discardableResult
public func >= (left: FreeLayoutAttribute, right: CGFloat) -> NSLayoutConstraint {
    if let spv = left.view.superview {
        var toItem: UIView? = spv
        var constant: CGFloat = right
        if left.attribute == .width || left.attribute == .height {
            toItem = nil
        }
        if left.attribute == .bottom || left.attribute == .right {
            constant = -constant
        }
        return spv.qs.constraint(item: left.view,
                                 attribute: left.attribute,
                                 relatedBy: .greaterThanOrEqual,
                                 toItem: toItem,
                                 constant: constant)
    }
    return NSLayoutConstraint()
}

@discardableResult
public func <= (left: FreeLayoutAttribute, right: CGFloat) -> NSLayoutConstraint {
    if let spv = left.view.superview {
        var toItem: UIView? = spv
        var constant: CGFloat = right
        if left.attribute == .width || left.attribute == .height {
            toItem = nil
        }
        if left.attribute == .bottom || left.attribute == .right {
            constant = -constant
        }
        return spv.qs.constraint(item: left.view,
                                 attribute: left.attribute,
                                 relatedBy: .lessThanOrEqual,
                                 toItem: toItem,
                                 constant: constant)
    }
    return NSLayoutConstraint()
}

public func == (left: FreeLayoutAttribute, right: UIEdgeInsets) {
    if let spv = left.view.superview {
        let toItem: UIView? = spv
        spv.qs.constraint(item: left.view,
                          attribute: .left,
                          toItem: toItem,
                          attribute: .left,
                          constant: right.left)
        spv.qs.constraint(item: left.view,
                          attribute: .right,
                          toItem: toItem,
                          attribute: .right,
                          constant: -right.right)
        spv.qs.constraint(item: left.view,
                          attribute: .top,
                          toItem: toItem,
                          attribute: .top,
                          constant: right.top)
        spv.qs.constraint(item: left.view,
                          attribute: .bottom,
                          toItem: toItem,
                          attribute: .bottom,
                          constant: -right.bottom)
    }
}



// MARK: - UILayoutGuide
@available(iOS 9.0, *)
public struct FreeLayoutYAxisAnchor {
    let anchor: NSLayoutYAxisAnchor
    let constant: CGFloat
    
    init(anchor: NSLayoutYAxisAnchor, constant: CGFloat = 0) {
        self.anchor = anchor
        self.constant = constant
    }
}

@available(iOS 9.0, *)
public struct FreeLayoutXAxisAnchor {
    let anchor: NSLayoutXAxisAnchor
    let constant: CGFloat
    
    init(anchor: NSLayoutXAxisAnchor, constant: CGFloat = 0) {
        self.anchor = anchor
        self.constant = constant
    }
}

@available(iOS 9.0, *)
public extension QSwiftBox where Base: UILayoutGuide {

    var top: FreeLayoutYAxisAnchor {
        return FreeLayoutYAxisAnchor(anchor: base.topAnchor)
    }

    var bottom: FreeLayoutYAxisAnchor {
        return FreeLayoutYAxisAnchor(anchor: base.bottomAnchor)
    }
    
    var left: FreeLayoutXAxisAnchor {
        return FreeLayoutXAxisAnchor(anchor: base.leftAnchor)
    }
    
    var right: FreeLayoutXAxisAnchor {
        return FreeLayoutXAxisAnchor(anchor: base.rightAnchor)
    }
    
    var leading: FreeLayoutXAxisAnchor {
        return FreeLayoutXAxisAnchor(anchor: base.leadingAnchor)
    }
    
    var trailing: FreeLayoutXAxisAnchor {
        return FreeLayoutXAxisAnchor(anchor: base.trailingAnchor)
    }

    var centerX: FreeLayoutXAxisAnchor {
        return FreeLayoutXAxisAnchor(anchor: base.centerXAnchor)
    }
    
    var centerY: FreeLayoutYAxisAnchor {
        return FreeLayoutYAxisAnchor(anchor: base.centerYAnchor)
    }
}

@available(iOS 9.0, *)
@discardableResult
public func == (left: FreeLayoutAttribute, right: FreeLayoutYAxisAnchor) -> NSLayoutConstraint {
    
    var constraint = NSLayoutConstraint()
    
    if left.attribute == .top {
        constraint = left.view.topAnchor.constraint(equalTo: right.anchor, constant: right.constant)
    }
    
    if left.attribute == .bottom {
        constraint = left.view.bottomAnchor.constraint(equalTo: right.anchor, constant: right.constant)
    }
    
    if left.attribute == .centerY {
        constraint = left.view.centerYAnchor.constraint(equalTo: right.anchor, constant: right.constant)
    }
    
    constraint.isActive = true
    return constraint
}

@available(iOS 9.0, *)
@discardableResult
public func == (left: FreeLayoutAttribute, right: FreeLayoutXAxisAnchor) -> NSLayoutConstraint {
    
    var constraint = NSLayoutConstraint()
    
    if left.attribute == .left {
        constraint = left.view.leftAnchor.constraint(equalTo: right.anchor, constant: right.constant)
    }
    
    if left.attribute == .right {
        constraint = left.view.rightAnchor.constraint(equalTo: right.anchor, constant: right.constant)
    }
    
    if left.attribute == .leading {
        constraint = left.view.leadingAnchor.constraint(equalTo: right.anchor, constant: right.constant)
    }
    
    if left.attribute == .trailing {
        constraint = left.view.trailingAnchor.constraint(equalTo: right.anchor, constant: right.constant)
    }
    
    if left.attribute == .centerX {
        constraint = left.view.centerXAnchor.constraint(equalTo: right.anchor, constant: right.constant)
    }
    
    constraint.isActive = true
    return constraint
}

@available(iOS 9.0, *)
@discardableResult
public func + (left: FreeLayoutYAxisAnchor, right: CGFloat) -> FreeLayoutYAxisAnchor {
    return FreeLayoutYAxisAnchor(anchor: left.anchor, constant: right)
}

@available(iOS 9.0, *)
@discardableResult
public func - (left: FreeLayoutYAxisAnchor, right: CGFloat) -> FreeLayoutYAxisAnchor {
    return FreeLayoutYAxisAnchor(anchor: left.anchor, constant: -right)
}

@available(iOS 9.0, *)
@discardableResult
public func + (left: FreeLayoutXAxisAnchor, right: CGFloat) -> FreeLayoutXAxisAnchor {
    return FreeLayoutXAxisAnchor(anchor: left.anchor, constant: right)
}

@available(iOS 9.0, *)
@discardableResult
public func - (left: FreeLayoutXAxisAnchor, right: CGFloat) -> FreeLayoutXAxisAnchor {
    return FreeLayoutXAxisAnchor(anchor: left.anchor, constant: -right)
}

// UILayoutSupport

@available(iOS 9.0, *)
public extension UILayoutSupport {
    
    var Top: FreeLayoutYAxisAnchor {
        return FreeLayoutYAxisAnchor(anchor: topAnchor)
    }
    
    var Bottom: FreeLayoutYAxisAnchor {
        return FreeLayoutYAxisAnchor(anchor: bottomAnchor)
    }
}
