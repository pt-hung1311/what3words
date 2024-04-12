//
//  TrendingNavigator.swift
//  what3words
//
//  Created by Hùng Phạm on 10/4/24.
//

import UIKit

protocol TrendingNavigatorType {
    func toDetail(id: Int)
    func toSearch(keyword: String)
}

struct TrendingNavigator: TrendingNavigatorType {
    unowned let assembler: Assembler
    unowned let navigationController: UINavigationController
    
    func toDetail(id: Int) {
        let vc: DetailViewController = assembler.resolve(navigationController: navigationController, id: id)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func toSearch(keyword: String) {
        let vc: SearchViewController = assembler.resolve(navigationController: navigationController, keyword: keyword)
        navigationController.pushViewController(vc, animated: true)
    }
}
