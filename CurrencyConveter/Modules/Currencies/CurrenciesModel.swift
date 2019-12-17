//
//  CurrenciesModel.swift
//  CurrencyConveter
//
//  Created by Eissa on 11/30/19.
//  Copyright © 2019 Eissa. All rights reserved.
//

import ObjectMapper

class CurrenciesModel: BaseModel {
    var base = ""
    var rates: [String: Double] = [:]
    var date = Date()
    override func mapping(map: Map) {
        super.mapping(map: map)
        base <- map["base"]
        rates <- map["rates"]
        date <- (map["date"], DateTransform())
    }
}
