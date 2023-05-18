//
//  SetCurrencyViewModel.swift
//  moneyspentiOS
//
//  Created by Kalaiselvan C on 16/05/23.
//

import Foundation
import RxSwift
import RxRelay

class SetCurrencyViewModel {
    let eventRelay = PublishRelay<SetCurrencyScreenEvents>()
    
    func saveCurrencyAsCompleteable(name: String) {
        _ = saveName(name: name)
            .subscribe(onCompleted: {
                self.eventRelay.accept(SetCurrencyScreenEvents.success)
            }, onError: { e in
                print(e)
                self.eventRelay.accept(SetCurrencyScreenEvents.failure)
            }, onDisposed: {
                
            })
    }
    
    private func saveName(name: String) -> Completable {
        return Completable.create { completable in
            UserDefaults.standard.set(name, forKey: "user_currency")
            completable(.completed)
            return Disposables.create()
        }
        
    }
}

enum SetCurrencyScreenEvents {
    case success
    case failure
}
