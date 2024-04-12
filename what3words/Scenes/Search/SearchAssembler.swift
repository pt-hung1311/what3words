//
//  SearchAssembler.swift
//  what3words
//
//  Created by Hùng Phạm on 10/4/24.
//

import UIKit

protocol SearchAssembler {
    func resolve(navigationController: UINavigationController, keyword: String) -> SearchViewController
    func resolve(navigationController: UINavigationController, keyword: String) -> SearchViewModel
    func resolve(navigationController: UINavigationController) -> SearchNavigatorType
    func resolve() -> SearchUseCaseType
}
extension SearchAssembler {
    func resolve(navigationController: UINavigationController, keyword: String) -> SearchViewController {
        let vc = SearchViewController.instantiate()
        let vm: SearchViewModel = resolve(navigationController: navigationController, keyword: keyword)
        vc.bindViewModel(to: vm)
        return vc
    }

    func resolve(navigationController: UINavigationController, keyword: String) -> SearchViewModel {
        return SearchViewModel(
            navigator: resolve(navigationController: navigationController),
            useCase: resolve(),
            keyword: keyword
        )
    }
}

extension SearchAssembler where Self: DefaultAssembler {
    func resolve(navigationController: UINavigationController) -> SearchNavigatorType {
        return SearchNavigator(assembler: self, navigationController: navigationController)
    }

    func resolve() -> SearchUseCaseType {
        return SearchUseCase(context: resolve(), movieGateway: resolve())
    }
}
