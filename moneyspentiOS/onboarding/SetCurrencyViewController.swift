//
//  SetCurrencyViewController.swift
//  moneyspentiOS
//
//  Created by Kalaiselvan C on 03/05/23.
//

import UIKit
import RxSwift
import RxCocoa

class SetCurrencyViewController: UIViewController {
    
    @IBOutlet weak var currencyTableView: UITableView!
    @IBOutlet weak var nextButton: UIButton!
    
    let viewModel = SetCurrencyViewModel()
    let disposeBag = DisposeBag()
    
    var currencySelected: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.isEnabled = false
        registerCell()
        bindView()
        bindEvents()
    }
    
    func bindEvents() {
        viewModel.eventRelay.subscribe {  [weak self] event in
            if let events = event.element {
                switch events {
                case .success:
                    print("success")
                    self?.performSegue(withIdentifier: "onboardingToHome", sender: self)
                case .failure:
                    print("error in navigating to set currency screen")
                }
            }
        }.disposed(by: disposeBag)
    }
    
    private func bindView() {
        let currencies = Observable.just(["Rupee", "Dollar", "Euro", "Pound"])
        currencies.bind(to: currencyTableView.rx.items(cellIdentifier: "currencycell", cellType: CurrencyTableViewCell.self)) { (row, element, cell) in
            let currencyCell = cell as CurrencyTableViewCell
            currencyCell.itemLabel.text = element
        }.disposed(by: disposeBag)
        
        currencyTableView.rx.modelSelected(String.self)
            .subscribe { [weak self] event in
                if let item = event.element {
                    self?.currencySelected = item
                    self?.nextButton.isEnabled = true
                }
            }.disposed(by: disposeBag)
        
        nextButton.rx.tap
            .subscribe { [weak self] event in
                self?.viewModel.saveCurrencyAsCompleteable(name: self?.currencySelected! ?? "Rupee")
            }.disposed(by: disposeBag)
    }
    
    private func registerCell() {
        let textFieldCell = UINib(nibName: "CurrencyTableViewCell",bundle: nil)
        self.currencyTableView.register(textFieldCell,forCellReuseIdentifier: "currencycell")
        self.currencyTableView.rowHeight = 60.0
    }
    
}
