//
//  ProfileViewController.swift
//  moneyspentiOS
//
//  Created by Kalaiselvan C on 15/05/23.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var insightView: UIView!
    @IBOutlet weak var expenseView: UIView!
    @IBOutlet weak var currencyView: UIView!
    @IBOutlet weak var categoryView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryView.layer.borderWidth = 0.3
        categoryView.layer.cornerRadius = 8.0
        insightView.layer.borderWidth = 0.3
        insightView.layer.cornerRadius = 8.0
        expenseView.layer.borderWidth = 0.3
        expenseView.layer.cornerRadius = 8.0
        currencyView.layer.borderWidth = 0.3
        currencyView.layer.cornerRadius = 8.0
    }
}
