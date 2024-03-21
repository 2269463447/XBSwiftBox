//
//  FormListView.swift
//  XBSwiftBox
//
//  Created by mac mini on 2024/3/21.
//

import UIKit

public class FormListView: UIScrollView {
    
    //内边距
    public var formEdgeInsets: UIEdgeInsets = .zero {
        didSet {
            viewArray.forEach {
                guard let _ = $0.superview else { return }
                $0.constraints.filter { $0.firstAttribute == .leading }.first?.constant = self.formEdgeInsets.left
                $0.constraints.filter { $0.firstAttribute == .trailing }.first?.constant = self.formEdgeInsets.right
            }
            viewArray.first?.constraints.filter { $0.firstAttribute == .top }.first?.constant = self.formEdgeInsets.top
            viewArray.last?.constraints.filter { $0.firstAttribute == .bottom }.first?.constant = -self.formEdgeInsets.bottom
        }
    }
    //元素间距
    public var spacing: CGFloat = 0 {
        didSet {
            for subview in viewArray {
                subview.constraints.filter { $0.firstAttribute == .top }.first?.constant = self.spacing
            }
        }
    }
    
    private let contentView = UIView()
    private var viewArray = [UIView]()
    private weak var lastConstraint: NSLayoutConstraint?
    private var lastView: UIView? {
        get {
            for view in viewArray.reversed() {
                if view.isHidden {
                    continue
                }
                return view
            }
            return nil
        }
    }
    
    // MARK: - Override
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    // MARK: - Private
    private func commonInit() {
        alwaysBounceVertical = true
        backgroundColor = .white
        contentView.backgroundColor = .clear
        
        self.addSubview(contentView)
        contentView.qs.edges == .zero
        contentView.qs.width == self.qs.width
    }
    
    // MARK: - Public
    @discardableResult
    public func append(_ view: UIView, for spacing: CGFloat = 0, animated: Bool = false) -> UIView {
        //添加子视图
        let superview = self.contentView
        let lastView = self.lastView
        superview.addSubview(view)
        
        if lastView != nil {
            lastConstraint?.isActive = false
        }
        var topConstraint: NSLayoutConstraint?
        view.qs.leading == superview.qs.leading + formEdgeInsets.left
        view.qs.trailing == superview.qs.trailing - formEdgeInsets.right
        if let lastView = self.lastView {
            topConstraint = view.qs.top == lastView.qs.bottom + spacing
        } else {
            topConstraint = view.qs.top == superview.qs.top + formEdgeInsets.top
        }
        lastConstraint = view.qs.bottom == superview.qs.bottom - formEdgeInsets.bottom
        if animated {
            var heightConstraint = view.constraints.filter { $0.firstAttribute == .height }.first
            var height: CGFloat?
            if heightConstraint == nil {
                heightConstraint = view.qs.height == 0
            } else {
                height = heightConstraint?.constant
                heightConstraint?.constant = 0
            }
            topConstraint?.constant = 0
            view.alpha = 0
            self.layoutIfNeeded()
            
            if let tmp = height {
                heightConstraint?.constant = tmp
            } else {
                heightConstraint?.isActive = false
            }
            if lastView != nil {
                topConstraint?.constant = spacing
            } else {
                topConstraint?.constant = formEdgeInsets.top
            }
            UIView.animate(withDuration: 0.4) {
                view.alpha = 1
                self.layoutIfNeeded()
            }
        }
        
        viewArray.append(view)
        return view
    }
}
