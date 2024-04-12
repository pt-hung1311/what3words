//
//  TrendingAssembler.swift
//  what3words
//
//  Created by Hùng Phạm on 10/4/24.
//

import UIKit

protocol TrendingAssembler {
    func resolve(navigationController: UINavigationController) -> TrendingViewController
    func resolve(navigationController: UINavigationController) -> TrendingViewModel
    func resolve(navigationController: UINavigationController) -> TrendingNavigatorType
    func resolve() -> TrendingUseCaseType
}
extension TrendingAssembler {
    func resolve(navigationController: UINavigationController) -> TrendingViewController {
        let vc = TrendingViewController.instantiate()
        let vm: TrendingViewModel = resolve(navigationController: navigationController)
        vc.bindViewModel(to: vm)
        return vc
    }

    func resolve(navigationController: UINavigationController) -> TrendingViewModel {
        return TrendingViewModel(
            navigator: resolve(navigationController: navigationController),
            useCase: resolve()
        )
    }
}

extension TrendingAssembler where Self: DefaultAssembler {
    func resolve(navigationController: UINavigationController) -> TrendingNavigatorType {
        return TrendingNavigator(assembler: self, navigationController: navigationController)
    }

    func resolve() -> TrendingUseCaseType {
        return TrendingUseCase(context: resolve(), movieGateway: resolve())
    }
}
