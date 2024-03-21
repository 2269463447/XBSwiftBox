//
//  CustomNavigationBar.swift
//  XBSwiftBox
//
//  Created by mac mini on 2024/3/21.
//

import UIKit

public class CustomNavigationBar: UIView {
    
    public enum AlphaMode {
        case auto //自动改变透明度
        case manual //手动改变透明度
    }
    private let offsetKeyPath = "contentOffset"
    
    //透明变化模式，默认为自动
    public var mode: AlphaMode = .auto
    //自动模式下，透明度与偏移量的比率关系，默认每个偏移点增加0.02透明度
    public var scalePerPoint: CGFloat = 0.02
    //标题
    public var title: String? {
        didSet {
            titleLabel.text = self.title
        }
    }
    //背景色，默认为白色
    public var barBackgroundColor: UIColor = .white {
        didSet {
            backgroundImageView.isHidden = true
            backgroundView.isHidden = false
            backgroundView.backgroundColor = self.barBackgroundColor
        }
    }
    //背景图片
    public var barBackgroundImage: UIImage? {
        didSet {
            backgroundView.isHidden = true
            backgroundImageView.isHidden = false
            backgroundImageView.image = self.barBackgroundImage
        }
    }
    //返回按钮点击回调
    public var backHandler: (() -> Void)?
    //自定义更新回调
    public var customConfigure: ((UIScrollView, CustomNavigationBar) -> Void)?
    
    //标题Label
    public let titleLabel = UILabel()
    //返回按钮
    public let backButton = UIButton()
    //背景视图
    private let backgroundView = UIView()
    //背景图片视图
    private let backgroundImageView = UIImageView()
    //监听的scrollView
    private var scrollView: UIScrollView?
    
    // MARK: - Override
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupView()
    }
    
    deinit {
        unregisterScrollView()
    }
    
    override public func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        guard let superview = self.superview else { return }
        self.leadingAnchor.constraint(equalTo: superview.leadingAnchor).isActive = true
        self.trailingAnchor.constraint(equalTo: superview.trailingAnchor).isActive = true
        self.topAnchor.constraint(equalTo: superview.topAnchor).isActive = true
        if #available(iOS 11.0, *) {
            self.bottomAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.topAnchor, constant: 44).isActive = true
        } else {
            self.heightAnchor.constraint(equalToConstant: 64).isActive = true
        }
    }
    
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if offsetKeyPath == keyPath {
            if let _ = object as? UIScrollView {
                updateUI()
            }
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    // MARK: - Private
    private func setupView() {
        self.backgroundColor = .clear
        backgroundView.backgroundColor = .white
        
        backgroundImageView.isHidden = true
        
        titleLabel.textColor = .black
        titleLabel.font = UIFont.systemFont(ofSize: 18)
        titleLabel.textAlignment = .center
        
        backButton.imageView?.contentMode = .center
        backButton.addTarget(self, action: #selector(clickBack), for: .touchUpInside)
        backButton.isHidden = true
        
        let contentView = UIView()
        
        self.addSubview(backgroundView)
        self.addSubview(backgroundImageView)
        self.addSubview(contentView)
        contentView.addSubview(backButton)
        contentView.addSubview(titleLabel)
        
        let superview = self
        
        backgroundView.qs.edges == .zero
        backgroundImageView.qs.edges == .zero
        
        contentView.qs.leading == superview.qs.leading
        contentView.qs.trailing == superview.qs.trailing
        contentView.qs.bottom == superview.qs.bottom
        contentView.qs.height == 44
        
        titleLabel.qs.centerX == contentView.qs.centerX
        titleLabel.qs.centerY == contentView.qs.centerY
        
        backButton.qs.leading == contentView.qs.leading
        backButton.qs.top == contentView.qs.top
        backButton.qs.bottom == contentView.qs.bottom
    }
    
    @objc
    private func clickBack() {
        backHandler?()
    }
    
    private func updateUI() {
        guard let scrollView = self.scrollView else { return }
        
        if mode == .manual {
            customConfigure?(scrollView, self)
            return
        }
        
        var offset = scrollView.contentOffset.y
        offset += scrollView.contentInset.top
        if #available(iOS 11.0, *) {
            offset += scrollView.adjustedContentInset.top
        }
        let alpha = offset * scalePerPoint
        if alpha < 0 {
            setBackgroundAlpha(0)
        } else if alpha < 1 {
            setBackgroundAlpha(alpha)
        } else {
            setBackgroundAlpha(1)
        }
    }
    
    // MARK: - Public
    //注册scrollView，将检测tableview的contentOffset来更新自己的UI
    public func register(_ scrollView: UIScrollView) {
        self.scrollView = scrollView
        scrollView.addObserver(self, forKeyPath: offsetKeyPath, options: [.initial, .new], context: nil)
    }
    
    //注销scrollView，需在合适的时机注销注册，让对象得以释放
    public func unregisterScrollView() {
        //移除监听
        self.scrollView?.removeObserver(self, forKeyPath: offsetKeyPath)
        self.scrollView = nil
    }
    
    public func setBackgroundAlpha(_ alpha: CGFloat) {
        backgroundView.alpha = alpha
        backgroundImageView.alpha = alpha
    }
}
