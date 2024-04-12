//
//  AppViewModel.swift
//  what3words
//
//  Created by Hùng Phạm on 10/4/24.
//

import RxSwift
import RxCocoa

struct AppViewModel {
    let navigator: AppNavigatorType
    let useCase: AppUseCaseType
}

// MARK: - ViewModel
extension AppViewModel: ViewModel {
    struct Input {
        let load: Driver<Void>
    }
    
    struct Output {
        
    }
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        input.load
            .drive(onNext: navigator.toTrending)
            .disposed(by: disposeBag)
        
        return Output()
    }
}
