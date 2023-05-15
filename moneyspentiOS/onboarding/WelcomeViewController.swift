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
    
    private var userName: String?
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
        bindViews()
        bindEvents()
    }
    
    func bindEvents() {
        viewmodel.eventRelay.subscribe { event in
            if let element = event.element {
                print("received")
                if element == "saved" {
                    let storyBoard: UIStoryboard = UIStoryboard(name: "OnboardingStoryboard", bundle: nil)
                    let balanceViewController = storyBoard.instantiateViewController(withIdentifier: "setcurrency") as! SetCurrencyViewController
                    self.present(balanceViewController, animated: true, completion: nil)
                }
            }
        }.disposed(by: disposeBag)
    }
    
    func bindViews() {
        nameTextField.rx.text.orEmpty.subscribe { [weak self] event in
            if let element = event.element {
                self?.userName = element
            }
        }.disposed(by: self.disposeBag)
        
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
