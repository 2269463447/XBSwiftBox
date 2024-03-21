//
//  StackBuilder.swift
//  XBSwiftBox
//
//  Created by mac mini on 2024/3/21.
//

import UIKit

class SpacerView: UIView {
    var contentSize = CGSize.zero
    
    override var intrinsicContentSize: CGSize {
        return contentSize
    }
}

public class StackBuilder {
    public private(set) var stackView: UIStackView
    
    init(stackView: UIStackView) {
        self.stackView = stackView
    }
    
    // MARK: - Public
    @discardableResult
    public func add(with some: Any) -> Self {
        var obj: Any?
        if some is StackBuilder {
            let builder = some as! StackBuilder
            obj = builder.stackView
        } else if some is UIView {
            obj = some as? UIView
        }
        
        guard let view = obj as? UIView else { return self }
        
        stackView.addArrangedSubview(view)
        
        return self
    }
    
    @discardableResult
    public func add(_ closure: () -> Any) -> Self {
        var obj = closure()
        while obj is () -> Any {
            let tmp = obj as! () -> Any
            obj = tmp()
        }
        if obj is StackBuilder {
            let builder = obj as! StackBuilder
            obj = builder.stackView
        }
        
        guard let view = obj as? UIView else { return self }
        
        stackView.addArrangedSubview(view)
        
        return self
    }
    
    @discardableResult
    public func remove(_ obj: Any) -> Self {
        var view: Any
        if obj is StackBuilder {
            let builder = obj as! StackBuilder
            view = builder.stackView
        } else {
            view = obj
        }
        guard let subview = view as? UIView else { return self }
        
        stackView.removeArrangedSubview(subview)
        
        return self
    }
    
    @discardableResult
    public func insert(_ obj: Any, _ index: Int) -> Self {
        var view: Any
        if obj is StackBuilder {
            let builder = obj as! StackBuilder
            view = builder.stackView
        } else {
            view = obj
        }
        guard let subview = view as? UIView else { return self }
        
        stackView.insertArrangedSubview(subview, at: index)
        
        return self
    }
    
    @discardableResult
    public func spacer(_ spacing: CGFloat) -> Self {
        let lastView = stackView.arrangedSubviews.last
        if lastView == nil {
            addSpacer(spacing)
            return self
        }
        if #available(iOS 11.0, *) {
            stackView.setCustomSpacing(spacing, after: lastView!)
        } else {
            addSpacer(spacing)
        }
        return self
    }
    
    // MARK: - Private
    private func addSpacer(_ spacing: CGFloat) {
        let view = SpacerView()
        view.backgroundColor = .clear
        var size = CGSize.zero
        if stackView.axis == .horizontal {
            size = CGSize(width: spacing, height: 1)
        } else {
            size = CGSize(width: 1, height: spacing)
        }
        view.contentSize = size
        stackView.addArrangedSubview(view)
    }
}

public func buildStack(_ config: (UIStackView) -> Void) -> StackBuilder {
    let stackView = UIStackView()
    config(stackView)
    return StackBuilder(stackView: stackView)
}

