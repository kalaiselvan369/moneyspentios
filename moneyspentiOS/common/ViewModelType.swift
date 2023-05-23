//
//  ViewModelType.swift
//  moneyspentiOS
//
//  Created by Kalaiselvan C on 23/05/23.
//

import Foundation

protocol ViewModelType {
    
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
