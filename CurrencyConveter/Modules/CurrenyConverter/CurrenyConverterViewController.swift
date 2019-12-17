//
//  CurrenyConverterViewController.swift
//  CurrencyConveter
//
//  Created by Eissa on 11/30/19.
//  Copyright © 2019 Eissa. All rights reserved.
//

import UIKit
import RxSwift

class CurrenyConverterViewController: BaseViewController {

    // MARK: - Outlets
    @IBOutlet weak var baseLBL: UILabel!
    @IBOutlet weak var baseTF: UITextField!
    @IBOutlet weak var currencyLBL: UILabel!
    @IBOutlet weak var currencyTF: UITextField!
    
    // MARK: - Variables
    let viewModel: CurrenyConverterViewModel
    let base: String // for ui
    let code: String // for ui

    // MARK: - Life Cycle
    init(base :String, currency: CCurrency) {
        self.base = base
        self.code = currency.code
        self.viewModel = CurrenyConverterViewModel(currency: currency)
        super.init(nibName: "CurrenyConverterViewController", bundle: .main)
        self.title = base
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    // MARK: - Functions
    override func setupView() {
        super.setupView()
        baseLBL.text = base
        currencyLBL.text = code
    }
    override func bindViewsToViewModel() {
        baseTF.rx.text.orEmpty.map({Double($0) ?? 0}).bind(to: viewModel.baseInPut).disposed(by: disposeBag)
        currencyTF.rx.text.orEmpty.map({Double($0) ?? 0}).bind(to: viewModel.currenyInPut).disposed(by: disposeBag)
    }
    override func bindViewModelToViews() {
        viewModel.baseOutPut.asDriver(onErrorJustReturn: 0).map({String($0)}).drive(baseTF.rx.text).disposed(by: disposeBag)
        viewModel.currenyOutPut.asDriver(onErrorJustReturn: 0).map({String($0)}).drive(currencyTF.rx.text).disposed(by: disposeBag)
    }
    // MARK: - Actions
}
