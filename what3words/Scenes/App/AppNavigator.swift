//
//  AppNavigator.swift
//  what3words
//
//  Created by Hùng Phạm on 10/4/24.
//

import UIKit

protocol AppNavigatorType {
    func toTrending()
}

struct AppNavigator: AppNavigatorType {
    unowned let assembler: Assembler
    unowned let window: UIWindow
    
    func toTrending() {
        let nav = UINavigationController()
        let vc: TrendingViewController = assembler.resolve(navigationController: nav)
        nav.viewControllers.append(vc)
        
        window.rootViewController = nav
        window.makeKeyAndVisible()
    }
}
