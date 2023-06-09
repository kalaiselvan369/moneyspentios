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
    
    let eventRelay = PublishRelay<WelcomeScreenEvents>()
    
    func saveNameAsCompleteable(name: String) {
        _ = saveName(name: name)
            .subscribe(onCompleted: {
                self.eventRelay.accept(WelcomeScreenEvents.success)
            }, onError: { e in
                print(e)
                self.eventRelay.accept(WelcomeScreenEvents.failure)
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

enum WelcomeScreenEvents{
    case success
    case failure
}


