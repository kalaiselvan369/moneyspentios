//
//  AddExpenseViewController.swift
//  moneyspentiOS
//
//  Created by Kalaiselvan C on 15/05/23.
//

import UIKit
import RxSwift
import RxCocoa


class AddExpenseViewController: UIViewController {
    
    @IBOutlet weak var saveExpenseButton: UIButton!
    @IBOutlet weak var amountInputField: UITextField!
    @IBOutlet weak var categoryPicker: UIPickerView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    let viewModel = AddExpenseViewModel()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindCategoryPickerContent()
        
        let tapBackground = UITapGestureRecognizer()
        tapBackground.rx.event
            .subscribe(onNext: { [weak self] _ in
                self?.view.endEditing(true)
            })
            .disposed(by: disposeBag)
        view.addGestureRecognizer(tapBackground)
        
        let input = AddExpenseViewModel.Input(
            datePicked: datePicker.rx.date.asObservable(),
            categoryPicked: categoryPicker.rx.modelSelected(String.self).asObservable(),
            amountEntered: amountInputField.rx.text.orEmpty.asObservable(),
            saveClicked: saveExpenseButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        output.saved.drive().disposed(by: disposeBag)
        
        viewModel.fetchExpense().subscribe(onSuccess: {expenses in
            for expense in expenses {
                print("\(expense.amount) \(expense.category) \(expense.date)")
            }
        }, onFailure: {error in
            print(error)
        }, onDisposed: {
            print("fetch expense disposed")
        }).disposed(by: disposeBag)
    }
    
    func bindCategoryPickerContent() {
        let items = Observable.just(["Fuel", "Groceries", "Medicine", "Travel", "Rent"])
        items.bind(to: categoryPicker.rx.itemTitles) { _, item in
            return item
        }.disposed(by: disposeBag)
    }
    
}
