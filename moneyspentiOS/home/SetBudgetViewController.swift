//
//  SetBudgetViewController.swift
//  moneyspentiOS
//
//  Created by Kalaiselvan C on 15/05/23.
//

import UIKit
import RxSwift
import RxCocoa

class SetBudgetViewController: UIViewController {
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var amount: UITextField!
    
    private let viewModel = SetBudgetViewModel()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapBackground = UITapGestureRecognizer()
        tapBackground.rx.event
            .subscribe(onNext: { [weak self] _ in
                self?.view.endEditing(true)
            })
            .disposed(by: disposeBag)
        view.addGestureRecognizer(tapBackground)
        bind()
    }
    
    func bind() {
        
        let input = SetBudgetViewModel.Input(budget: amount.rx.text.orEmpty.asObservable(), save: saveButton.rx.tap.asObservable())
        
        let output = viewModel.transform(input: input)
        
        output.saved.drive().disposed(by: disposeBag)
        
        viewModel.fetchBudget().subscribe(onSuccess: {budgets in
            for budget in budgets {
                print(budget.amount)
            }
        }, onFailure: {e in
            print(e)
        }, onDisposed: {
            print("fetch budget disposed")
        }).disposed(by: disposeBag)
    }
}
