//
//  UITextInput+SwiftBox.swift
//  XBSwiftBox_Example
//
//  Created by mac mini on 2023/11/2.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit

private var TextInputLimiterKey = "TextInputLimiterKey"

@objc
fileprivate protocol TextInputLimiter: UITextFieldDelegate, UITextViewDelegate {
    
    func textInputView(_ inputView: UITextInput, shouldChangeTextIn range: NSRange, replacement text: String) -> Bool
    
    @objc
    func textInputViewDidChange(_ inputView: UITextInput)
    
}

fileprivate class DefaultTextInputLimiter: NSObject, TextInputLimiter {
    
    var maxLength: Int = -1
    
    var changeHandler: ((String?) -> Void)?
    
    func textInputView(_ inputView: UITextInput, shouldChangeTextIn range: NSRange, replacement text: String) -> Bool {
        
        if maxLength < 0 {
            return true
        }
        //如果有高亮且当前字数开始位置小于最大限制时允许输入
        if let selectedRange = inputView.markedTextRange, let _ = inputView.position(from: selectedRange.start, offset: 0) {
            let startOffset = inputView.offset(from: inputView.beginningOfDocument, to: selectedRange.start)
            let endOffset = inputView.offset(from: inputView.beginningOfDocument, to: selectedRange.end)
            let offsetRange = NSMakeRange(startOffset, endOffset - startOffset)
            return offsetRange.location < maxLength
        }
        var currentText: NSString = ""
        if let textField = inputView as? UITextField, let tmp = textField.text {
            currentText = tmp as NSString
        }
        if let textView = inputView as? UITextView, let tmp = textView.text {
            currentText = tmp as NSString
        }
        
        let comcatStr = currentText.replacingCharacters(in: range, with: text)
        let canInputLen = maxLength - comcatStr.count
        if canInputLen >= 0 {
            return true
        }
        let len = text.count + canInputLen
        //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
        let rg = NSMakeRange(0, max(len, 0))
        if rg.length > 0 {
            var s = ""
            //判断是否只普通的字符或asc码(对于中文和表情返回NO)
            if text.canBeConverted(to: .ascii) {
                let tmpText = text as NSString
                s = tmpText.substring(with: rg)
            } else {
                var idx = 0
                var trimString = ""
                text.enumerateSubstrings(in: text.startIndex ..< text.endIndex) { substring, _, _, stop in
                    if idx >= rg.length {
                        stop = true
                        return
                    }
                    trimString = trimString.appending(substring ?? "")
                    idx = idx + 1
                }
                s = trimString
            }
            //rang是指从当前光标处进行替换处理(注意如果执行此句后面返回的是YES会触发didchange事件)
            let tmp = currentText.replacingCharacters(in: range, with: s)
            if let textField = inputView as? UITextField {
                textField.text = tmp
            }
            if let textView = inputView as? UITextView {
                textView.text = tmp
            }
        }
        
        return false
    }
    
    func textInputViewDidChange(_ inputView: UITextInput) {
        defer {
            var text = ""
            if let textField = inputView as? UITextField, let tmp = textField.text {
                text = tmp
            }
            if let textView = inputView as? UITextView, let tmp = textView.text {
                text = tmp
            }
            changeHandler?(text)
        }
        
        if maxLength < 0 {
            return
        }
        //如果在变化中是高亮部分在变，就不要计算字符了
        if let selectedRange = inputView.markedTextRange, let _ = inputView.position(from: selectedRange.start, offset: 0) {
            return
        }
        var currentText = ""
        if let textField = inputView as? UITextField, let tmp = textField.text {
            currentText = tmp
        }
        if let textView = inputView as? UITextView, let tmp = textView.text {
            currentText = tmp
        }
        if maxLength >= 0 && currentText.count > maxLength {
            let tmpText = currentText as NSString
            let s = tmpText.substring(with: NSMakeRange(0, maxLength))
            if let textField = inputView as? UITextField {
                textField.text = s
            }
            if let textView = inputView as? UITextView {
                textView.text = s
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let result = textInputView(textField, shouldChangeTextIn: range, replacement: string)
        if !result {
            textInputViewDidChange(textField)
        }
        return result
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let result = textInputView(textView, shouldChangeTextIn: range, replacement: text)
        if !result {
            textInputViewDidChange(textView)
        }
        return result
    }
    
    func textViewDidChange(_ textView: UITextView) {
        textInputViewDidChange(textView)
    }
}

extension XBSwiftBox where Base: UITextField {
    
    private var limiter: DefaultTextInputLimiter {
        get {
            if let limiter = objc_getAssociatedObject(base, &TextInputLimiterKey) as? DefaultTextInputLimiter {
                return limiter
            }
            let limiter = DefaultTextInputLimiter()
            self.limiter = limiter
            return limiter
        }
        set {
            objc_setAssociatedObject(base, &TextInputLimiterKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public func setLimit(length: Int, changeHandler: ((String?) -> Void)? = nil) {
        limiter.maxLength = length
        base.delegate = limiter
        base.addTarget(limiter, action: #selector(limiter.textInputViewDidChange(_:)), for: .editingChanged)
        limiter.changeHandler = changeHandler
    }
    
}

extension XBSwiftBox where Base: UITextView {
    
    private var limiter: DefaultTextInputLimiter {
        get {
            if let limiter = objc_getAssociatedObject(base, &TextInputLimiterKey) as? DefaultTextInputLimiter {
                return limiter
            }
            let limiter = DefaultTextInputLimiter()
            self.limiter = limiter
            return limiter
        }
        set {
            objc_setAssociatedObject(base, &TextInputLimiterKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public func setLimit(length: Int, changeHandler: ((String?) -> Void)? = nil) {
        limiter.maxLength = length
        base.delegate = limiter
        limiter.changeHandler = changeHandler
    }
    
}

