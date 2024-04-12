//
//  DetailAssembler.swift
//  what3words
//
//  Created by Hùng Phạm on 10/4/24.
//

import UIKit

protocol DetailAssembler {
    func resolve(navigationController: UINavigationController, id: Int) -> DetailViewController
    func resolve(navigationController: UINavigationController, id: Int) -> DetailViewModel
    func resolve(navigationController: UINavigationController) -> DetailNavigatorType
    func resolve() -> DetailUseCaseType
}
extension DetailAssembler {
    func resolve(navigationController: UINavigationController, id: Int) -> DetailViewController {
        let vc = DetailViewController.instantiate()
        let vm: DetailViewModel = resolve(navigationController: navigationController, id: id)
        vc.bindViewModel(to: vm)
        return vc
    }

    func resolve(navigationController: UINavigationController, id: Int) -> DetailViewModel {
        return DetailViewModel(
            navigator: resolve(navigationController: navigationController),
            useCase: resolve(),
            id: id
        )
    }
}

extension DetailAssembler where Self: DefaultAssembler {
    func resolve(navigationController: UINavigationController) -> DetailNavigatorType {
        return DetailNavigator(assembler: self, navigationController: navigationController)
    }

    func resolve() -> DetailUseCaseType {
        return DetailUseCase(context: resolve(), movieGateway: resolve())
    }
}
