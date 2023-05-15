//
//  WelcomeViewModel.swift
//  moneyspentiOS
//
//  Created by Kalaiselvan C on 03/05/23.
//

import Foundation
import RxSwift
import RxRelay

class WelcomeViewModel {
    
    let eventRelay = PublishRelay<String>()
    
    func saveNameAsCompleteable(name: String) {
        _ = saveName(name: name)
            .subscribe(onCompleted: {
                print("accepting")
                self.eventRelay.accept("saved")
            }, onError: { e in
                print(e)
            }, onDisposed: {
                
            })
    }
    
    private func saveName(name: String) -> Completable {
        return Completable.create { completable in
            UserDefaults.standard.set(name, forKey: "user_name")
            completable(.completed)
            return Disposables.create()
        }
        
    }
}


