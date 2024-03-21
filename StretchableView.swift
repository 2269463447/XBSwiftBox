//
//  StretchableView.swift
//  XBSwiftBox
//
//  Created by mac mini on 2024/3/21.
//

import UIKit

public class StretchableView: UIView {
    
    public enum StretchType {
        case `default` //默认高度拉伸
        case scale //按比例缩放
        case custom //自定义模式
    }
    private let offsetKeyPath = "contentOffset"
    
    //拉伸类型
    public var type: StretchType = .default
    //使用自定义模式需要自己实现拉伸的回调
    public var customStretchHandler: ((UIScrollView, UIImageView) -> Void)?
    public let backgroundView: UIImageView = UIImageView()
    
    private var scrollView: UIScrollView?
    private var initialFrame: CGRect!
    
    // MARK: - Override
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        commonInit()
    }
    
    // KVO
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == offsetKeyPath {
            if let _ = object as? UIScrollView {
                updateUI()
            }
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    override public var frame: CGRect {
        didSet {
            backgroundView.frame = self.bounds
            initialFrame = backgroundView.frame
        }
    }
    
    deinit {
        unregisterScrollView()
    }
    
    // MARK: - Private
    private func commonInit() {
        //默认初始化
        backgroundView.frame = self.bounds
        initialFrame = backgroundView.frame
        self.insertSubview(backgroundView, at: 0)
    }
    
    private func updateUI() {
        guard let scrollView = self.scrollView else { return }
        
        var offset = scrollView.contentOffset.y
        offset += scrollView.contentInset.top
        if #available(iOS 11.0, *) {
            offset += scrollView.adjustedContentInset.top
        }
        //拉伸类型
        if type == .default {
            if offset >= 0 {
                return
            }
            var frame = CGRect.zero
            frame.origin.y = offset
            frame.size.width = backgroundView.frame.size.width
            frame.size.height = initialFrame.size.height - offset
            backgroundView.frame = frame
        } else if type == .scale {
            if offset >= 0 {
                return
            }
            var frame = CGRect.zero
            frame.origin.x = offset / 2
            frame.origin.y = offset
            frame.size.width = initialFrame.size.width - offset
            frame.size.height = initialFrame.size.height - offset
            backgroundView.frame = frame
        } else if type == .custom {
            customStretchHandler?(scrollView, backgroundView)
        }
    }
    
    // MARK: - Public
    //注册scrollView，将检测tableview的contentOffset来更新自己的UI
    public func register(scrollView: UIScrollView) {
        self.scrollView = scrollView
        scrollView.addObserver(self, forKeyPath: offsetKeyPath, options: [.initial, .new], context: nil)
    }
    
    //注销scrollView，需在合适的时机注销注册，让对象得以释放
    public func unregisterScrollView() {
        //移除监听
        self.scrollView?.removeObserver(self, forKeyPath: offsetKeyPath)
        self.scrollView = nil
    }
    
    //设置背景图
    public func set(backgroundImage: UIImage?) {
        backgroundView.image = backgroundImage
    }
}
