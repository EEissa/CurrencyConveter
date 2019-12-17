//
//  BaseModel.swift
//  CurrencyConveter
//
//  Created by Eissa on 12/17/19.
//  Copyright © 2019 Eissa. All rights reserved.
//

import ObjectMapper

class BaseModel: Mappable {
    init() {}
    required init?(map: Map) {}
    func mapping(map: Map) {}
}
