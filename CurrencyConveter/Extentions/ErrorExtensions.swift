//
//  ErrorExtensions.swift
//  Hrafyeen
//
//  Created by Eissa on 10/27/19.
//  Copyright © 2019 Essam. All rights reserved.
//

import Foundation
extension NSError {
    convenience init(_ error: String) {
        self.init(domain: error, code: -1, userInfo: nil)
    }
}
//func getErrorMessage(byCode code: Int) -> String {
//    guard path = Bundle.main.path(forResource: "Errors", ofType: "plist"),
//        let dictionary = NSDictionary(contentsOfFile: path) as [String : String] else {
//            return "Error \(code)"
//    }
//    return dictionary[String(code), default: "Error \(code)"]
//}
