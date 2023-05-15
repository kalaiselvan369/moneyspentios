//
//  HomeViewController.swift
//  moneyspentiOS
//
//  Created by Kalaiselvan C on 03/05/23.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "MainToOnboarding", sender: self)
    }
    
}
