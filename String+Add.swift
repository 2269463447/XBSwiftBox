//
//  String+Add.swift
//  XBSwiftBox
//
//  Created by mac mini on 2024/3/21.
//

import Foundation

extension String {
    public var containsChineseCharacters: Bool {
        return self.range(of: "\\p{Han}", options: .regularExpression) != nil
    }
    
    public var isAllLetters: Bool {
        var isAll = true
        
        for eachChar in self {
            if !( ((eachChar >= "A") && (eachChar <= "Z")) || ((eachChar >= "a") && (eachChar <= "z")) ){
                isAll = false
                break
            }
        }
        return isAll
    }
    public var isAllDigits: Bool {
        var isAll = true
        
        for eachChar in self {
            if !((eachChar >= "0") && (eachChar <= "9")){
                isAll = false
                break
            }
        }
        
        return isAll
    }
}
