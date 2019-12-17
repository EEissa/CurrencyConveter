//
//  NetworkEnums.swift
//  CurrencyConveter
//
//  Created by Eissa on 7/8/19.
//  Copyright © 2019 Eissa. All rights reserved.
//

enum Auth {
    case bearer(String)
    case custom(type: String, token: String)
    case none
}
extension Auth {
    var value: [String: String] {
        switch self {
        case .bearer(let token):
            return ["Authorization": "Bearer \(token)"]
        case .custom(let type,let token):
            return [type: token]
        default:
            return [:]
        }
    }
}
enum RequestType {
    case session
    case upload
    case download
}
