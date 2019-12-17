//
//  BaseViewController.swift
//  CurrencyConveter
//
//  Created by Eissa on 11/30/19.
//  Copyright © 2019 Eissa. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class BaseViewController: UIViewController {

    // MARK: - Outlets
    let disposeBag = DisposeBag()

    // MARK: - Variables
    
    // MARK: - LifeCycle
    deinit {
        print("\(type(of: self)) dinit")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindViewsToViewModel()
        bindViewModelToViews()
    }
    func setupView()  {}
    func bindViewsToViewModel() {}
    func bindViewModelToViews() {}
    
    // MARK: - Functions
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    // MARK: - Actions
}

