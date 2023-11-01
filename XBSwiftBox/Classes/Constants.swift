//
//  Constants.swift
//  XBSwiftBox_Example
//
//  Created by mac mini on 2023/11/1.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit

// 屏幕宽度
public let ScreenWidth = UIScreen.main.bounds.width
// 屏幕高度
public let ScreenHeight = UIScreen.main.bounds.height
// 导航栏高度
public let NavBarHeight = UIApplication.shared.statusBarFrame.height + 44
//系统版本
public let SysVersion = UIDevice.current.systemVersion
//分界线宽度
public let SeparatorWidth = (1.0 / UIScreen.main.scale)
//应用版本
public let AppVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
//设备UUID
public let DeviceUUID = UIDevice.current.identifierForVendor?.uuidString

// Tab栏高度
public var TabBarHeight: CGFloat {
    get {
        var height: CGFloat = 49
        if #available(iOS 11.0, *) {
            if let delegate = UIApplication.shared.delegate, let window = delegate.window as? UIWindow {
                height += window.safeAreaInsets.bottom
            }
        }
        
        return height
    }
}


//Json转Model
public func fastMap<T: Decodable>(_ data: Any, forType type:T.Type) -> T? {
    if let parseData = data as? [String:Any] {
        let jsonData = try? JSONSerialization.data(withJSONObject: parseData as Any, options: .prettyPrinted)
        if let json = jsonData {
            let model = try? JSONDecoder().decode(T.self, from: json)
            return model
        }
    } else if let parseData = data as? [Any] {
        let jsonData = try? JSONSerialization.data(withJSONObject: parseData as Any, options: .prettyPrinted)
        if let json = jsonData {
            let model = try? JSONDecoder().decode(T.self, from: json)
            return model
        }
    } else if let parseData = data as? T {
        return parseData
    }
    return nil
}

//创建线性渐变
public func linearGradient(colors: [UIColor], size: CGSize = CGSize(width: 1, height: 1), deg: CGFloat = 90) -> CAGradientLayer {
    
    let angle = 360 - deg
    var startPoint = CGPoint.zero
    var endPoint = CGPoint.zero
    if angle <= 0 || angle >= 360 {
        startPoint.x = 0.5
        startPoint.y = 0
        endPoint.x = 0.5
        endPoint.y = 1
    } else if angle < 45 {
        startPoint.x = 0.5 + 0.5 * tan(angle / 180.0 * .pi)
        startPoint.y = 0
        endPoint.x = 0.5 - 0.5 * tan(angle / 180.0 * .pi)
        endPoint.y = 1
    } else if angle <= 90 {
        startPoint.x = 1
        startPoint.y = 0.5 - 0.5 * tan((90 - angle) / 180.0 * .pi)
        endPoint.x = 0
        endPoint.y = 0.5 + 0.5 * tan((90 - angle) / 180.0 * .pi)
    } else if angle < 135 {
        startPoint.x = 0
        startPoint.y = 0.5 + 0.5 * tan((angle - 90) / 180.0 * .pi)
        endPoint.x = 1
        endPoint.y = 0.5 - 0.5 * tan((angle - 90) / 180.0 * .pi)
    } else if angle <= 180 {
        startPoint.x = 0.5 + 0.5 * tan((180 - angle) / 180.0 * .pi)
        startPoint.y = 1
        endPoint.x = 0.5 - 0.5 * tan((180 - angle) / 180.0 * .pi)
        endPoint.y = 0
    } else if angle < 225 {
        startPoint.x = 0.5 - 0.5 * tan((angle - 180) / 180.0 * .pi)
        startPoint.y = 1
        endPoint.x = 0.5 + 0.5 * tan((angle - 180) / 180.0 * .pi)
        endPoint.y = 0
    } else if angle <= 270 {
        startPoint.x = 0
        startPoint.y = 0.5 + 0.5 * tan((270 - angle) / 180.0 * .pi)
        endPoint.x = 1
        endPoint.y = 0.5 - 0.5 * tan((270 - angle) / 180.0 * .pi)
    } else if angle < 315 {
        startPoint.x = 0
        startPoint.y = 0.5 - 0.5 * tan((angle - 270) / 180.0 * .pi)
        endPoint.x = 1
        endPoint.y = 0.5 + 0.5 * tan((angle - 270) / 180.0 * .pi)
    } else if angle < 360 {
        startPoint.x = 0.5 - 0.5 * tan((360 - angle) / 180.0 * .pi)
        startPoint.y = 0
        endPoint.x = 0.5 + 0.5 * tan((360 - angle) / 180.0 * .pi)
        endPoint.y = 1
    }
    
    let gradientLayer = CAGradientLayer()
    gradientLayer.frame = CGRect(origin: .zero, size: size)
    gradientLayer.colors = colors.map { $0.cgColor }
    gradientLayer.startPoint = startPoint
    gradientLayer.endPoint = endPoint
    return gradientLayer
}

//颜色
extension UIColor {
    public convenience init(_ hex:UInt, _ alpha: CGFloat) {
        let red = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((hex & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(hex & 0x0000FF) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}

//国际化
public func LocalizedString(_ key: String) -> String {
    return NSLocalizedString(key, comment: "")
}
//字体
extension UIFont {
    public class func regular(_ size: CGFloat) -> UIFont {
        let font = UIFont(name: "PingFangSC-Regular", size: size)
        if font == nil {
            return UIFont.systemFont(ofSize: size)
        }
        return font!
    }
    public class func light(_ size: CGFloat) -> UIFont {
        let font = UIFont(name: "PingFangSC-Light", size: size)
        if font == nil {
            return UIFont.systemFont(ofSize: size)
        }
        return font!
    }
    public class func semibold(_ size: CGFloat) -> UIFont {
        let font = UIFont(name: "PingFangSC-Semibold", size: size)
        if font == nil {
            return UIFont.systemFont(ofSize: size)
        }
        return font!
    }
    public class func medium(_ size: CGFloat) -> UIFont {
        let font = UIFont(name: "PingFangSC-Medium", size: size)
        if font == nil {
            return UIFont.systemFont(ofSize: size)
        }
        return font!
    }
    public class func din(_ size: CGFloat) -> UIFont {
        let font = UIFont(name: "DIN Condensed", size: size)
        if font == nil {
            return UIFont.systemFont(ofSize: size)
        }
        return font!
    }
    public class func dinBlack(_ size: CGFloat) -> UIFont {
        let font = UIFont(name: "DINAlternate-Bold", size: size)
        if font == nil {
            return UIFont.systemFont(ofSize: size)
        }
        return font!
    }
}
