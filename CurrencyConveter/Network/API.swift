//
//  API.swift
//  CurrencyConveter
//
//  Created by Eissa on 10/22/17.
//  Copyright © 2017 Mahmoud Eissa. All rights reserved.
//
//
import Alamofire
import RxSwift
final class API {
    // MARK:- Currencies
    static func fetchCurrencies(sucess: @escaping SuccessHandler<CurrenciesModel>, error: @escaping ErrorHandler) {
        let request = Request(path: "latest?access_key=\(access_key)")
        request.method = .get
        request.encoding = JSONEncoding.default
        APIClient.excute(request: request, sucess: sucess, error: error)
    }
    static func fetchCurrencies() -> Single<CurrenciesModel> {
        let request = Request(path: "latest?access_key=\(access_key)")
        request.method = .get
        request.encoding = JSONEncoding.default
       return APIClient.excute(request: request)
    }
}

