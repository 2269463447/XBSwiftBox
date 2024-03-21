//
//  Optional+Extension.swift
//  XBSwiftBox
//
//  Created by mac mini on 2024/3/21.
//

import Foundation

extension Swift.Optional where Wrapped == String {
    public var isBlank: Bool {
        return self?.isEmpty ?? true
    }
    
    public var isNotBlank: Bool {
        return !isBlank
    }
    
    public var text: String {
        return self ?? ""
    }
}

extension Swift.Optional where Wrapped == Int {
    public var string: String {
        return "\(self ?? 0)"
    }
}

extension Swift.Optional where Wrapped == Any {
    public subscript(index: String) -> Any? {
        get {
            if let dict = self as? [String: Any] {
                return dict[index]
            }
            return nil
        }
    }
}
