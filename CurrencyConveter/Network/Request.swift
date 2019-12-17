//
//  Request.swift
//  SMEH_ENG
//
//  Created by Mac on 2/12/19.
//  Copyright © 2019 Eissa. All rights reserved.
//

import Alamofire
import ObjectMapper

class Request {
    var baseUrl = ""
    private var path = ""
    var method = HTTPMethod.get
    var headers: HTTPHeaders?
    var body: Any?
    var auth = Auth.none
    var encoding: ParameterEncoding = URLEncoding.default
    var selection: [Nested] = []
    var fullHeaders: HTTPHeaders! {
        var contentType = ""
        switch encoding {
        case is JSONEncoding:
            contentType = "application/json"
        case is PropertyListEncoding:
            contentType = "application/x-plist"
        default:
            contentType = "x-www-form-urlencoded"
        }
        guard let header = headers else {
            return auth.value + ["Content-Type": contentType]
        }
        return ["Content-Type": contentType] + header + auth.value
    }
    var fullPath: String! {
        return (baseUrl + path).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }

    init( baseUrl: String = NetworkBaseUrl, path: String, method: HTTPMethod = .get, headers: HTTPHeaders? = nil, body: Any? = nil,  auth:  Auth = .none, encoding: ParameterEncoding = URLEncoding.default ) {
        self.baseUrl = baseUrl
        self.path = path
        self.method = method
        self.headers = headers
        self.body = body
        self.auth = auth
        self.encoding = encoding
    }
}
extension Request: CustomStringConvertible {
    var description: String {
        var str = "==================================================\n"
        str.append("\(method) --> \(fullPath!) \n")
        str.append("Headers --> \(fullHeaders ?? [:])\n")
        if let json = body as? [String: Any] {
            str.append("Body --> \(json.jsonString)\n")
            Swift.print()
        } else if let array = body as? [[String: Any]] {
            str.append("Body --> \(array.jsonString)\n")
        } else {
            str.append("Body --> \(body ?? "nil")\n")
        }
        str.append("==================")
        return str
    }
}
