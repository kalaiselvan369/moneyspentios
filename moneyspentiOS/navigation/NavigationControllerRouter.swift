//
//  NavigationControllerRouter.swift
//  moneyspentiOS
//
//  Created by Kalaiselvan C on 15/05/23.
//

import Foundation
import UIKit

class NavigationControllerRouter: NavigationDelegate {
    
    func navigateToWelcomeScreen() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "OnboardingStoryboard", bundle: nil)
         let welcomeViewController = storyBoard.instantiateViewController(withIdentifier: "OnboardingStoryBoard") as! WelcomeViewController
         self.present(welcomeViewController, animated: true, completion: nil)
    }
    
    func navigateToSetCurrencyScreen() {
        
    }
    
    func navigateToHomeScreen() {
        
    }
    
    func navigateToSetBudgetScreen() {
        
    }
    
    func navigateToAddExpenseScreen() {
        
    }
    
    func navigateToProfileScreen() {
        
    }
    
    
}
