//
//  WelcomeViewController.swift
//  moneyspentiOS
//
//  Created by Kalaiselvan C on 03/05/23.
//

import UIKit
import RxSwift
import RxCocoa

class WelcomeViewController: UIViewController {
    
    let viewmodel = WelcomeViewModel()
    let disposeBag = DisposeBag()
    let buttonState = PublishSubject<Bool>()
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
        nextButton.isEnabled = false
        bindViews()
        bindEvents()
    }
    
    func bindEvents() {
        viewmodel.eventRelay.subscribe { event in
            if let events = event.element {
                switch events {
                case .success:
                    self.performSegue(withIdentifier: "fromWelcomeToSetCurrency", sender: self)
                case .failure:
                    print("error in navigating to set currency screen")
                }
            }
        }.disposed(by: disposeBag)
    }
    
    func bindViews() {
        nameTextField.rx.text.orEmpty
            .map { text in
                if text.count >= 3 {
                    return true
                } else {
                    return false
                }
            }
            .bind(to: nextButton.rx.isEnabled)
            .disposed(by: self.disposeBag)
        
        nextButton.rx.tap
            .withLatestFrom(nameTextField.rx.text.orEmpty.asObservable())
            .subscribe { [weak self] event in
                if let element = event.element {
                    self?.viewmodel.saveNameAsCompleteable(name: element)
                }
                
            }.disposed(by: self.disposeBag)
    }
}

extension WelcomeViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text?.isEmpty != true {
            return true
        } else {
            textField.placeholder = "Enter your name"
            return false
        }
    }
}
