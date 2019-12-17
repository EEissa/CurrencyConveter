//
//  DictionaryExtensions.swift
//  Hrafyeen
//
//  Created by Essam on 10/23/19.
//  Copyright © 2019 Essam. All rights reserved.
//

import UIKit

extension Dictionary{
    var jsonString: String{
        if let theJSONData = try? JSONSerialization.data(
            withJSONObject: self,
            options: []) {
            let theJSONText = String(data: theJSONData,
                                     encoding: .utf8)
            return theJSONText ?? ""
        }
        return ""
    }
}

extension Sequence where Iterator.Element == [String: Any] {
    var jsonString: String{
    
        if let theJSONData = try? JSONSerialization.data(
            withJSONObject: self,
            options: []) {
            let theJSONText = String(data: theJSONData,
                                     encoding: .utf8)
            return theJSONText ?? ""
        }
        return ""
    }
}
extension Dictionary{
    static func +(one: Dictionary, two: Dictionary) -> Dictionary{
        var final = one
        for obj in two{
            final[obj.key] = obj.value
        }
        return final
    }
    static func +=(_ left: inout Dictionary, right: Dictionary) {
        left = left + right
    }
}
