//
//  AppAssembler.swift
//  what3words
//
//  Created by Hùng Phạm on 10/4/24.
//

import UIKit

protocol AppAssembler {
    func resolve(window: UIWindow) -> AppViewModel
    func resolve(window: UIWindow) -> AppNavigatorType
    func resolve() -> AppUseCaseType
}

extension AppAssembler {
    func resolve(window: UIWindow) -> AppViewModel {
        return AppViewModel(navigator: resolve(window: window), useCase: resolve())
    }
}

extension AppAssembler where Self: DefaultAssembler {
    func resolve(window: UIWindow) -> AppNavigatorType {
        return AppNavigator(assembler: self, window: window)
    }
    
    func resolve() -> AppUseCaseType {
        return AppUseCase(appGateway: resolve())
    }
}
