//
//  CurrenciesViewController.swift
//  CurrencyConveter
//
//  Created by Eissa on 11/30/19.
//  Copyright © 2019 Eissa. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CurrenciesViewController: BaseViewController {
  
  // MARK: - Outlets
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var baseCurrencyLBL: UILabel!
  
  // MARK: - Variables
  let viewModel = CurrenciesViewModel()
  private let identifier = "CurrencyTableViewCell"
  
  // MARK: - LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  // MARK: - Functions
  override func setupView() {
    // Setup
    tableView.register(UINib.init(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
    tableView.rx.modelSelected(CCurrency.self).subscribe(onNext: { [weak self] curreny in
      guard let self = self else { return }
      if let selectedRowIndexPath = self.tableView.indexPathForSelectedRow {
        self.tableView.deselectRow(at: selectedRowIndexPath, animated: true)
      }
      let controller = CurrenyConverterViewController(base: self.baseCurrencyLBL.text!, currency: curreny)
      self.navigationController?.pushViewController(controller, animated: true)
    }).disposed(by: disposeBag)
    // Fetch data
    viewModel.fetchCurrencies()
  }
  
  override func bindViewModelToViews() {
    viewModel.base.asDriver(onErrorJustReturn: "-").drive(baseCurrencyLBL.rx.text).disposed(by: disposeBag)
    viewModel.currencies.bind(to: tableView.rx.items(cellIdentifier: identifier)) { [weak self] (row,item,cell) in
      guard let self = self else { return }
      self.configureCell(row, item, cell)
    }.disposed(by: disposeBag)
    viewModel.isLoading.asDriver(onErrorJustReturn: false).drive(activityIndicator.rx.isAnimating).disposed(by: disposeBag)
    viewModel.error.subscribe(onNext: { [weak self] (error) in
      guard let self = self else { return }
      self.show(messageAlert: error.localizedDescription)
    }).disposed(by: disposeBag)
  }
  
  private func configureCell(_ row: Int,_ item: CCurrency ,_ cell: UITableViewCell) {
    guard let cell = cell as? CurrencyTableViewCell else {
      return
    }
    cell.currencyCodeLBL.text = item.code
    cell.valueLBL.text = String(item.valueRelativeToBase)
  }
  // MARK: - Actions
}

