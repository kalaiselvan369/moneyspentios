//
//  SetBudgetViewModel.swift
//  moneyspentiOS
//
//  Created by Kalaiselvan C on 23/05/23.
//

import Foundation
import RxSwift
import RxCocoa
import CoreData


class SetBudgetViewModel: ViewModelType {
    
    struct Input {
        let budget: Observable<String>
        let save: Observable<Void>
    }
    
    struct Output {
        let saved: Driver<Bool>
    }
    
    private let resultSubject = PublishSubject<Bool>()
    
    
    func transform(input: Input) -> Output {
        let result = input.save.withLatestFrom(combineInput(input: input))
            .flatMap { (amount, date) in
                self.addBudgetAsSingle(amount: amount, date: date)
            }.asDriver(onErrorJustReturn: false)
        
        return Output(saved: result)
    }
    
    func combineInput(input: Input) -> Observable<(Float, Date)> {
        let mappedAmount = input.budget.map { amountAsString in
            return Float(amountAsString) ?? 0.0
        }
        return Observable.combineLatest(mappedAmount, Observable.just(Date.now))
    }
    
    func addBudgetAsSingle(
        amount: Float,
        date: Date
    ) -> Single<Bool> {
        return Single<Bool>.create { single in
            let managedContext = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
            let budget = Budget(context: managedContext)
            print("\(amount), \(date)")
            budget.amount = amount
            budget.date = date
            do {
                try AppDelegate.sharedAppDelegate.coreDataStack.saveContext()
            } catch let error as NSError {
                single(.failure(error))
            }
            single(.success(true))
            return Disposables.create()
        }
    }
    
    func fetchBudget() -> Single<[Budget]> {
        return Single<[Budget]>.create { single in
            let budgets: NSFetchRequest<Budget> = Budget.fetchRequest()
            do {
                let managedContext = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
                let results = try managedContext.fetch(budgets)
                single(.success(results))
            } catch let error as NSError {
                print("Fetch error: \(error) description: \(error.userInfo)")
                single(.failure(error))
            }
            return Disposables.create()
        }
    }
    
}
