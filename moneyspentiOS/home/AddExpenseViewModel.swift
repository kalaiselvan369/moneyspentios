//
//  AddExpenseViewModel.swift
//  moneyspentiOS
//
//  Created by Kalaiselvan C on 19/05/23.
//

import Foundation
import RxSwift
import RxCocoa
import CoreData
import RxRelay

class AddExpenseViewModel: ViewModelType {
    
    struct Input {
        let datePicked: Observable<Date>
        let categoryPicked: Observable<[String]>
        let amountEntered: Observable<String>
        let saveClicked: Observable<Void>
    }
    
    struct Output {
        let saved: Driver<Bool>
    }
    
    func transform(input: Input) -> Output {
        
        let result = input.saveClicked
            .withLatestFrom(combineInput(input: input))
            .flatMap { (category, date, amount) in
                self.addExpenseAsSingle(amount: amount, date: date, category: category)
            }
            .asDriver(onErrorJustReturn: false)
        
        return Output(saved: result)
        
    }
    
    func combineInput(input: Input) -> Observable<(String, Date, Float)> {
        let mappedCategory = input.categoryPicked.map { categoryArray in
            return categoryArray.last ?? "Default"
        }
        
        let mappedAmount = input.amountEntered.map { amountAsString in
            return Float(amountAsString) ?? 0.0
        }
        return Observable.combineLatest(
            mappedCategory,
            input.datePicked,
            mappedAmount
        )
    }
    
    func fetchExpense() -> Single<[Expense]> {
        return Single<[Expense]>.create { single in
            let expenses: NSFetchRequest<Expense> = Expense.fetchRequest()
            do {
                let managedContext = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
                let results = try managedContext.fetch(expenses)
                single(.success(results))
            } catch let error as NSError {
                print("Fetch error: \(error) description: \(error.userInfo)")
                single(.failure(error))
            }
            return Disposables.create()
        }
    }
    
    func addExpenseAsSingle(
        amount: Float,
        date: Date,
        category: String
    ) -> Single<Bool> {
        return Single<Bool>.create { single in
            let managedContext = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
            let expense = Expense(context: managedContext)
            print("\(amount), \(date), \(category)")
            expense.amount = amount
            expense.date = date
            expense.category = category
            do {
                try AppDelegate.sharedAppDelegate.coreDataStack.saveContext()
            } catch let error as NSError {
                single(.failure(error))
            }
            single(.success(true))
            return Disposables.create()
        }
    }
}
