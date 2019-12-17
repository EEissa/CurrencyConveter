//
//  CurrenciesViewModel.swift
//  CurrencyConveter
//
//  Created by Eissa on 12/17/19.
//  Copyright © 2019 Eissa. All rights reserved.
//

import RxSwift
class CurrenciesViewModel {
    
    let currencies = BehaviorSubject<[CCurrency]>(value: [])
    let base = BehaviorSubject<String>(value: "-")
    let error =  PublishSubject<Error>()
    let isLoading = BehaviorSubject<Bool>(value: true)
    
    func fetchCurrencies()  {
        self.isLoading.onNext(true)
        API.fetchCurrencies(sucess: { [weak self]  (model) in
            guard let self = self else { return }
            self.isLoading.onNext(false)
            self.base.onNext(model.base)
            self.currencies.onNext(model.rates.map({.init(code: $0.key, valueRelativeToBase: $0.value)}))
        }) { (_error) in
            self.isLoading.onNext(false)
            self.error.onNext(_error)
        }
    }
}
