//
//  XBSwiftBox.swift
//  XBSwiftBox_Example
//
//  Created by mac mini on 2023/11/2.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation


// MARK: - QSwiftBox命名空间
public final class XBSwiftBox<Base> {
    public let base: Base
    public init(_ base: Base) {
        self.base = base
    }
}

public protocol XBSwiftBoxCompatible {
    associatedtype CompatibleType
    var xb: CompatibleType { get }
}

public extension XBSwiftBoxCompatible {
    var xb: XBSwiftBox<Self> {
        return XBSwiftBox(self)
    }
}

//添加qs扩展
extension NSObject: XBSwiftBoxCompatible { }
