//
//  CurrenyConverterViewModel.swift
//  CurrencyConveter
//
//  Created by Eissa on 12/17/19.
//  Copyright © 2019 Eissa. All rights reserved.
//

import RxSwift
import RxCocoa
class CurrenyConverterViewModel {

    let baseInPut = BehaviorRelay.init(value: 0.0)
    let currenyInPut = BehaviorRelay.init(value: 0.0)
    let baseOutPut = PublishSubject<Double>()
    let currenyOutPut = PublishSubject<Double>()
    
    let disposeBag  = DisposeBag()
    let currency: CCurrency
    init(currency: CCurrency) {
        self.currency = currency
        setup()
    }
   private func setup()  {
        let ratio = currency.valueRelativeToBase
        baseInPut.asDriver(onErrorJustReturn: 0).map({ ratio * $0}).drive(currenyOutPut).disposed(by: disposeBag)
        currenyInPut.asDriver(onErrorJustReturn: 0).map({ (1/ratio) * $0}).drive(baseOutPut).disposed(by: disposeBag)
    }
}
